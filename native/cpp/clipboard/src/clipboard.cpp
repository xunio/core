#define IMPLEMENT_API

#include <hx/CFFI.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xmu/Atoms.h>

/* no context */
#define XCLIB_XCOUT_NONE 0
/* sent a request */
#define XCLIB_XCOUT_SENTCONVSEL 1
/* in an incr loop */
#define XCLIB_XCOUT_INCR 2
/* UTF8_STRING failed, need fallback to XA_STRING */
#define XCLIB_XCOUT_FALLBACK 3

/* xcin() contexts */
#define XCLIB_XCIN_NONE 0
#define XCLIB_XCIN_SELREQ 1
#define XCLIB_XCIN_INCR 2

/* X display to connect to */
char *sdisp = NULL;
int sloop = 0; /* number of loops */
/* X selection to work with */
Atom sseln = XA_PRIMARY;
Atom target = XA_STRING;
Display *dpy;

/* a strdup() implementation since ANSI C doesn't include strdup() */
void *xcstrdup(const char *string) {
    void *mem;
    /* allocate a buffer big enough to hold the characters and the
     * null terminator, then copy the string into the buffer
     */
    mem = malloc(strlen(string) + sizeof(char));
    strcpy(mem, string);
    return (mem);
}

/* Retrieves the contents of a selections. Arguments are:
 *
 * A display that has been opened.
 *
 * A window
 *
 * An event to process
 *
 * The selection to return
 *
 * The target(UTF8_STRING or XA_STRING) to return
 *
 * A pointer to a char array to put the selection into.
 *
 * A pointer to a long to record the length of the char array
 *
 * A pointer to an int to record the context in which to process the event
 *
 * Return value is 1 if the retrieval of the selection data is complete,
 * otherwise it's 0.
 */
bool xcout(Display *dpy, Window win, XEvent evt, Atom sel, Atom target, unsigned char **txt, unsigned long *len, unsigned int *context) {
    /* a property for other windows to put their selection into */
    static Atom pty;
    static Atom inc;
    Atom pty_type;
    Atom atomUTF8String;
    int pty_format;

    /* buffer for XGetWindowProperty to dump data into */
    unsigned char *buffer;
    unsigned long pty_size, pty_items;

    /* local buffer of text to return */
    unsigned char *ltxt = *txt;

    if (!pty) {
        pty = XInternAtom(dpy, "XCLIP_OUT", False);
    }

    if (!inc) {
        inc = XInternAtom(dpy, "INCR", False);
    }

    switch (*context) {
        /* there is no context, do an XConvertSelection() */
        case XCLIB_XCOUT_NONE:
            /* initialise return length to 0 */
            if (*len > 0) {
                free(*txt);
                *len = 0;
            }

            /* send a selection request */
            XConvertSelection(dpy, sel, target, pty, win, CurrentTime);
            *context = XCLIB_XCOUT_SENTCONVSEL;
            return false;
        case XCLIB_XCOUT_SENTCONVSEL:
            atomUTF8String = XInternAtom(dpy, "UTF8_STRING", False);
            if (evt.type != SelectionNotify)
                return false;

            /* fallback to XA_STRING when UTF8_STRING failed */
            if (target == atomUTF8String && evt.xselection.property == None) {
                *context = XCLIB_XCOUT_FALLBACK;
                return false;
            }

            /* find the size and format of the data in property */
            XGetWindowProperty(dpy,
                       win,
                       pty,
                       0,
                       0,
                       False,
                       AnyPropertyType, &pty_type, &pty_format, &pty_items, &pty_size, &buffer);
            XFree(buffer);

            if (pty_type == inc) {
                /* start INCR mechanism by deleting property */
                XDeleteProperty(dpy, win, pty);
                XFlush(dpy);
                *context = XCLIB_XCOUT_INCR;
                return false;
            }

            /* if it's not incr, and not format == 8, then there's
             * nothing in the selection (that xclip understands,
             * anyway)
             */
            if (pty_format != 8) {
                *context = XCLIB_XCOUT_NONE;
                return false;
            }

            /* not using INCR mechanism, just read the property */
            XGetWindowProperty(dpy,
                       win,
                       pty,
                       0,
                       (long) pty_size,
                       False,
                       AnyPropertyType, &pty_type, &pty_format, &pty_items, &pty_size, &buffer);

            /* finished with property, delete it */
            XDeleteProperty(dpy, win, pty);

            /* copy the buffer to the pointer for returned data */
            ltxt = (unsigned char *) malloc(pty_items);
            memcpy(ltxt, buffer, pty_items);

            /* set the length of the returned data */
            *len = pty_items;
            *txt = ltxt;

            /* free the buffer */
            XFree(buffer);

            *context = XCLIB_XCOUT_NONE;

            /* complete contents of selection fetched, return 1 */
            return true;

        case XCLIB_XCOUT_INCR:
            /* To use the INCR method, we basically delete the
             * property with the selection in it, wait for an
             * event indicating that the property has been created,
             * then read it, delete it, etc.
             */

            /* make sure that the event is relevant */
            if (evt.type != PropertyNotify)
                return false;

            /* skip unless the property has a new value */
            if (evt.xproperty.state != PropertyNewValue)
                return false;

            /* check size and format of the property */
            XGetWindowProperty(dpy,
                       win,
                       pty,
                       0,
                       0,
                       False,
                       AnyPropertyType,
                       &pty_type,
                       &pty_format, &pty_items, &pty_size, (unsigned char **) &buffer);

            if (pty_format != 8) {
                /* property does not contain text, delete it
                 * to tell the other X client that we have read
                 * it and to send the next property
                 */
                XFree(buffer);
                XDeleteProperty(dpy, win, pty);
                return false;
            }

            if (pty_size == 0) {
                /* no more data, exit from loop */
                XFree(buffer);
                XDeleteProperty(dpy, win, pty);
                *context = XCLIB_XCOUT_NONE;

                /* this means that an INCR transfer is now
                 * complete, return 1
                 */
                return true;
            }

            XFree(buffer);

            /* if we have come this far, the propery contains
             * text, we know the size.
             */
            XGetWindowProperty(dpy,
                       win,
                       pty,
                       0,
                       (long) pty_size,
                       False,
                       AnyPropertyType,
                       &pty_type,
                       &pty_format, &pty_items, &pty_size, (unsigned char **) &buffer);

            /* allocate memory to accommodate data in *txt */
            if (*len == 0) {
                *len = pty_items;
                ltxt = (unsigned char *) malloc(*len);
            }
            else {
                *len += pty_items;
                ltxt = (unsigned char *) realloc(ltxt, *len);
            }

            /* add data to ltxt */
            memcpy(&ltxt[*len - pty_items], buffer, pty_items);

            *txt = ltxt;
            XFree(buffer);

            /* delete property to get the next item */
            XDeleteProperty(dpy, win, pty);
            XFlush(dpy);
            return false;
    }

    return false;
}

/* put data into a selection, in response to a SelecionRequest event from
 * another window (and any subsequent events relating to an INCR transfer).
 *
 * Arguments are:
 *
 * A display
 *
 * A window
 *
 * The event to respond to
 *
 * A pointer to an Atom. This gets set to the property nominated by the other
 * app in it's SelectionRequest. Things are likely to break if you change the
 * value of this yourself.
 *
 * The target(UTF8_STRING or XA_STRING) to respond to
 *
 * A pointer to an array of chars to read selection data from.
 *
 * The length of the array of chars.
 *
 * In the case of an INCR transfer, the position within the array of chars
 * that is being processed.
 *
 * The context that event is the be processed within.
 */
bool xcin(Display * dpy, Window * win, XEvent evt, Atom * pty, Atom target, unsigned char *txt, unsigned long len, unsigned long *pos, unsigned int *context) {
    unsigned long chunk_len; /* length of current chunk (for incrtransfers only) */
    XEvent res; /* response to event */
    static Atom inc;
    static Atom targets;
    static long chunk_size;

    if (!targets) {
        targets = XInternAtom(dpy, "TARGETS", False);
    }

    if (!inc) {
        inc = XInternAtom(dpy, "INCR", False);
    }

    /* We consider selections larger than a quarter of the maximum
       request size to be "large". See ICCCM section 2.5 */
    if (!chunk_size) {
        chunk_size = XExtendedMaxRequestSize(dpy) / 4;
        if (!chunk_size) {
            chunk_size = XMaxRequestSize(dpy) / 4;
        }
    }

    switch (*context) {
        case XCLIB_XCIN_NONE:
            if (evt.type != SelectionRequest)
                return false;

            /* set the window and property that is being used */
            *win = evt.xselectionrequest.requestor;
            *pty = evt.xselectionrequest.property;

            /* reset position to 0 */
            *pos = 0;

            /* put the data into an property */
            if (evt.xselectionrequest.target == targets) {
                Atom types[2] = { targets, target };

                /* send data all at once (not using INCR) */
                XChangeProperty(dpy,
                        *win,
                        *pty,
                        XA_ATOM,
                        32, PropModeReplace, (unsigned char *) types,
                        (int) (sizeof(types) / sizeof(Atom))
                );
            } else if (len > chunk_size) {
                /* send INCR response */
                XChangeProperty(dpy, *win, *pty, inc, 32, PropModeReplace, 0, 0);

                /* With the INCR mechanism, we need to know
                 * when the requestor window changes (deletes)
                 * its properties
                 */
                XSelectInput(dpy, *win, PropertyChangeMask);

                *context = XCLIB_XCIN_INCR;
            } else {
                /* send data all at once (not using INCR) */
                XChangeProperty(dpy,
                        *win,
                        *pty, target, 8, PropModeReplace, (unsigned char *) txt, (int) len);
            }

            /* Perhaps FIXME: According to ICCCM section 2.5, we should
               confirm that XChangeProperty succeeded without any Alloc
               errors before replying with SelectionNotify. However, doing
               so would require an error handler which modifies a global
               variable, plus doing XSync after each XChangeProperty. */

            /* set values for the response event */
            res.xselection.property = *pty;
            res.xselection.type = SelectionNotify;
            res.xselection.display = evt.xselectionrequest.display;
            res.xselection.requestor = *win;
            res.xselection.selection = evt.xselectionrequest.selection;
            res.xselection.target = evt.xselectionrequest.target;
            res.xselection.time = evt.xselectionrequest.time;

            /* send the response event */
            XSendEvent(dpy, evt.xselectionrequest.requestor, 0, 0, &res);
            XFlush(dpy);

            /* if len < chunk_size, then the data was sent all at
             * once and the transfer is now complete, return 1
             */
            if (len > chunk_size)
                return false;
            else
                return true;

            break;

        case XCLIB_XCIN_INCR:
            /* length of current chunk */

            /* ignore non-property events */
            if (evt.type != PropertyNotify)
                return false;

            /* ignore the event unless it's to report that the
             * property has been deleted
             */
            if (evt.xproperty.state != PropertyDelete)
                return false;

            /* set the chunk length to the maximum size */
            chunk_len = chunk_size;

            /* if a chunk length of maximum size would extend
             * beyond the end ot txt, set the length to be the
             * remaining length of txt
             */
            if ((*pos + chunk_len) > len)
                chunk_len = len - *pos;

            /* if the start of the chunk is beyond the end of txt,
             * then we've already sent all the data, so set the
             * length to be zero
             */
            if (*pos > len) {
                chunk_len = 0;
            }

            if (chunk_len) {
                /* put the chunk into the property */
                XChangeProperty(dpy,
                        *win, *pty, target, 8, PropModeReplace, &txt[*pos], (int) chunk_len);
            } else {
                /* make an empty property to show we've
                 * finished the transfer
                 */
                XChangeProperty(dpy, *win, *pty, target, 8, PropModeReplace, 0, 0);
            }
            XFlush(dpy);

            /* all data has been sent, break out of the loop */
            if (!chunk_len) {
                *context = XCLIB_XCIN_NONE;
            }

            *pos += chunk_size;

            /* if chunk_len == 0, we just finished the transfer,
             * return 1
             */
            if (chunk_len > 0)
                return false;
            else
                return true;
            break;
    }
    return false;
}

extern "C" {
    value getText() {
        Window win;

        /* Connect to the X server. */
        if (!(dpy = XOpenDisplay(sdisp))) {
            return val_null;
        }

        sseln = XA_CLIPBOARD(dpy);
        /* Create a window to trap events */
        win = XCreateSimpleWindow(dpy, DefaultRootWindow(dpy), 0, 0, 1, 1, 0, 0, 0);
        /* get events about property changes */
        XSelectInput(dpy, win, PropertyChangeMask);

        unsigned char *sel_buf; /* buffer for selection data */
        unsigned long sel_len = 0; /* length of sel_buf */
        XEvent evt; /* X Event Structures */
        unsigned int context = XCLIB_XCOUT_NONE;

        if (sseln == XA_STRING) {
            sel_buf = (unsigned char *) XFetchBuffer(dpy, (int *) &sel_len, 0);
        } else {
            while (1) {
                /* only get an event if xcout() is doing something */
                if (context != XCLIB_XCOUT_NONE) {
                    XNextEvent(dpy, &evt);
                }

                /* fetch the selection, or part of it */
                xcout(dpy, win, evt, sseln, target, &sel_buf, &sel_len, &context);

                /* fallback is needed. set XA_STRING to target and restart the loop. */
                if (context == XCLIB_XCOUT_FALLBACK) {
                    context = XCLIB_XCOUT_NONE;
                    target = XA_STRING;
                    continue;
                }

                /* only continue if xcout() is doing something */
                if (context == XCLIB_XCOUT_NONE) {
                    break;
                }
            }
        }

        /* Disconnect from the X server */
        XCloseDisplay(dpy);

        if (sel_len) {
            value ret = copy_string(sel_buf, sel_len);
            if (sseln == XA_STRING) {
                XFree(sel_buf);
            } else {
                free(sel_buf);
            }

            return ret;
        }

        return val_null;
    }

    bool _setText(Window win, unsigned char *sel_buf, unsigned long sel_len, bool &isfork) {
        int dloop = 0; /* done loops counter */
        XEvent evt;

        /* Handle cut buffer if needed */
        if (sseln == XA_STRING) {
            XStoreBuffer(dpy, (char *)sel_buf, (int)sel_len, 0);
            return true;
        }

        /* take control of the selection so that we receive
        * SelectionRequest events from other windows
        */
        /* FIXME: Should not use CurrentTime, according to ICCCM section 2.1 */
        XSetSelectionOwner(dpy, sseln, win, CurrentTime);

        /* fork into the background, exit parent process */
        pid_t pid;

        pid = fork();
        /* exit the parent process; */
        if (pid) {
            return true;
        } else {
            isfork = true;
        }

        /* Avoid making the current directory in use, in case it will need to be umounted */
        chdir("/");

        /* loop and wait for the expected number of
        * SelectionRequest events
        */
        while (dloop < sloop || sloop < 1) {
            /* wait for a SelectionRequest event */
            while (1) {
                static unsigned int clear = 0;
                static unsigned int context = XCLIB_XCIN_NONE;
                static unsigned long sel_pos = 0;
                static Window cwin;
                static Atom pty;
                int finished;

                XNextEvent(dpy, &evt);

                finished = xcin(dpy, &cwin, evt, &pty, target, sel_buf, sel_len, &sel_pos, &context);

                if (evt.type == SelectionClear) {
                    clear = 1;
                }

                if ((context == XCLIB_XCIN_NONE) && clear) {
                    return true;
                }

                if (finished) {
                    break;
                }
            }
            dloop++; /* increment loop counter */
        }
        return false;
    }

    value setText(value text) {
        if (val_is_string(text)) {
            Window win;

            /* Connect to the X server. */
            if (!(dpy = XOpenDisplay(sdisp))) {
                return val_false;
            }

            sseln = XA_CLIPBOARD(dpy);
            /* Create a window to trap events */
            win = XCreateSimpleWindow(dpy, DefaultRootWindow(dpy), 0, 0, 1, 1, 0, 0, 0);
            /* get events about property changes */
            XSelectInput(dpy, win, PropertyChangeMask);

            unsigned char *sel_buf; /* buffer for selection data */
            unsigned long sel_len = 0; /* length of sel_buf */
            unsigned int context = XCLIB_XCOUT_NONE;

            sel_buf = val_get_string(text);
            sel_len = strlen(sel_buf);

            bool isfork = false;

            bool ret = _setText(win, sel_buf, sel_len, isfork);

            /* Disconnect from the X server */
            if (isfork) {
                XCloseDisplay(dpy);
                exit(EXIT_SUCCESS);
            }

            if (ret) {
                return val_true;
            } else {
                return val_false;
            }
        }
        return val_false;
    }


}
DEFINE_PRIM( getText, 0 );
DEFINE_PRIM( setText, 1 );
