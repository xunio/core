package io.xun.core.event;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

#if !macro
using io.xun.ds.Bits;
#end

class ObserverMacro
{
	/**
	 * The number bits reserved for storing group ids.<br/>
	 * E.g. using 5 bits, a total of 32 group ids (0..31, 2^5-1) and 27 event ids (32 - 5) can be encoded in a 32-bit integer.
	 */
	inline public static var NUM_GROUP_BITS = 5;
	
	#if !macro
	/**
	 * The number of bits used for encoding the update type (group & event).
	 */
	inline public static var NUM_BITS = 32;
	
	/**
	 * The number of bits reserved for encoding event ids.
	 */
	inline public static var NUM_EVENT_BITS = 32 - NUM_GROUP_BITS;
	
	/**
	 * A bit mask of all possible event bits.
	 */
	inline public static var EVENT_MASK = (1 << NUM_EVENT_BITS) - 1;
	
	/**
	 * A bit mask of all possible group bits.
	 */
	inline public static var GROUP_MASK = ((1 << NUM_GROUP_BITS) - 1) << NUM_EVENT_BITS;
	
	/**
	 * Returns an iterator over all event bit flags stored in the update id <code>x</code>.
	 */
	public static function extractTypes(x:Int):Iterator<Int>
	{
		var g = x & ObserverMacro.GROUP_MASK;
		var e = x & ObserverMacro.EVENT_MASK;
		var i = 0;
		var s = e.ones();
		
		//process all events bits MSB -> LSB
		return
		{
			hasNext: function()
			{
				return i < s;
			},
			next: function()
			{
				//add group bits
				var type = g | e.msb();
				//remove bit so msb() returns the next most significant event bit
				e = e.clrBits(e.msb());
				i++;
				return type;
			}
		}
	}
	#end
	
	#if macro
	static var NUM_EVENT_BITS:Int;
	
	static var _groupCounter = 0;
	
	macro public static function create(e:Expr):Array<Field>
	{
		var numBits = Context.defined('neko') ? 30 : 32;
		NUM_EVENT_BITS = numBits - NUM_GROUP_BITS;
		
		if (_groupCounter > (1 << NUM_GROUP_BITS) - 1)
			Context.error('too many groups', Context.currentPos());
		
		var pos = Context.currentPos();
		var gid    = _groupCounter++;
		var tid    = 0;
		var names  = new Array<String>();
		var fields = new Array<Field>();
		
		switch (e.expr)
		{
			case EArrayDecl(a):
				if (a.length > NUM_EVENT_BITS) Context.error('too many types', pos);
				
				for (b in a)
				{
					switch (b.expr)
					{
						case EConst(c):
							switch (c)
							{
								case CIdent(d):
									fields.push(_makeTypeField(d, tid, gid, pos));
									names.push(d);
									tid++;
								
								default: Context.error('unsupported declaration', pos);
							}
						default: Context.error('unsupported declaration', pos);
					}
				}
			default: Context.error('unsupported declaration', pos);
		}
		
		fields.push(_makeNameFunc(names, gid, pos));
		fields.push(_makeGroupFunc(pos));
		fields.push(_makeGroupIdField(gid, pos));
		fields.push(_makeGroupMaskField(gid, pos));
		fields.push(_makeEventMaskField(names.length, pos));
		fields.push(_makeHasFunc(gid, names.length, pos));
		
		return fields;
	}
	
	macro public static function guid():Array<Field>
	{
		if (haxe.macro.Context.defined('display')) return null;
		var c = haxe.macro.Context.getLocalClass().get();
		while (c.superClass != null)
		{
			c = c.superClass.t.get();
			for (i in c.interfaces)
			{
				if (i.t.toString() == 'io.xun.core.event.IObserver')
					return null;
			}
		}
		var p = haxe.macro.Context.currentPos();
		var fields = Context.getBuildFields();
		for (field in fields)
		{
			if (field.name == 'new')
			{
				switch (field.kind)
				{
					case FFun(f):
						switch (f.expr.expr)
						{
							case ExprDef.EBlock(a):
								a.unshift({expr: EBinop(Binop.OpAssign, {expr: EConst(CIdent('__guid')), pos: p}, {expr: EConst(CInt('0')), pos: p}), pos: p});
							default:
						}
					default:
				}
				break;
			}
		}
		
		fields.push({name: '__guid', doc: null, meta: [], access: [APublic], kind: FVar(TPath({pack: [], name: 'Int', params: [], sub: null})), pos: p});
		return fields;
	}
	
	static function _makeHasFunc(gid, n, pos)
	{
		var a = EBinop(OpEq,
			{expr: EConst(CInt(Std.string(gid))), pos: pos},
			{expr: EBinop(OpUShr, {expr: EConst(CIdent('x')), pos: pos}, {expr: EConst(CInt(Std.string(NUM_EVENT_BITS))), pos: pos}), pos: pos});
		
		var f =
		{
			args: [{name: 'x', opt: false, type: TPath({pack: [], name: 'Int', params: [], sub: null}), value: null}],
			ret: TPath({pack: [], name: 'Bool', params: [], sub: null}),
			expr: {expr: EReturn({expr: a, pos: pos}), pos: pos},
			params: []
		}
		
		return {name: 'has', doc: null, meta: [], access: [AStatic, APublic, AInline], kind: FFun(f), pos: pos}
	}
	
	static function _makeGroupFunc(pos)
	{
		var f =
		{
			args: [{name: 'x', opt: false, type: TPath({pack: [], name: 'Int', params: [], sub: null}), value: null}],
			ret: TPath({pack: [], name: 'Int', params: [], sub: null}),
			expr: {expr: EReturn({expr: EBinop(OpUShr, {expr: EConst(CIdent('x')), pos: pos}, {expr: EConst(CInt(Std.string(NUM_EVENT_BITS))), pos: pos}), pos: pos}), pos: pos},
			params: []
		}
		
		return {name: 'group', doc: null, meta: [], access: [AStatic, APublic, AInline], kind: FFun(f), pos: pos}
	}
	
	static function _makeNameFunc(names:Array<String>, gid, p)
	{
		if (haxe.macro.Context.defined('display'))
		{
			var f =
			{
				args: [{name: 'x', opt: false, type: TPath({pack: [], name: 'Int', params: [], sub: null}), value: null}],
				ret: TPath({name: 'Array', pack: [], params: [TPType(TPath({name: 'String', pack: [], params: [], sub: null}))], sub: null}),
				expr: {expr: EBlock([]), pos: p},
				params: []
			}
			
			return {name: 'getName', doc: null, meta: [], access: [AStatic, APublic], kind: FFun(f), pos: p}
		}
		else
		{
			function maskExpr(typeShift:Int)
			{
				var p = haxe.macro.Context.currentPos();
				var a = EBinop(OpShl, {expr: EConst(CInt('1')), pos: p}, {expr: EConst(CInt(Std.string(typeShift))), pos: p});
				return EParenthesis({expr: a, pos: p});
			}
			
			var e = [];
			e.push({expr: EVars([{expr: {expr: ENew({name:'Array', pack: [], params: [TPType(TPath({name:'String', pack: [], params: [], sub: null}))], sub: null}, []), pos: p},
				name: 'output', type: TPath({name: 'Array', pack: [], params: [TPType(TPath({name: 'String', pack: [], params: [], sub: null}))], sub: null})}]), pos: p});
			for (i in 0...names.length)
			{
				e.push({expr: EVars([{expr: {expr: maskExpr(i), pos: p}, name: 'mask', type: TPath({name:'Int', pack: [], params: [], sub: null})}]), pos: p});
				e.push({expr: EIf(
					{expr: EBinop(OpGt, {expr: EBinop(OpAnd, {expr: EConst(CIdent('x')), pos: p}, {expr: EConst(CIdent('mask')), pos: p}), pos: p}, {expr: EConst(CInt('0')), pos: p}), pos: p},
					{expr: EBlock([{expr: ECall({expr: EField({expr: EConst(CIdent('output')), pos: p}, 'push'), pos: p}, [{expr: EConst(CString(names[i])), pos: p}]), pos: p}]), pos: p}, null), pos : p});
			}
			e.push({expr: EReturn({expr: EConst(CIdent('output')), pos: p}), pos : p});
			
			var f =
			{
				args: [{name: 'x', opt: false, type: TPath({pack: [], name: 'Int', params: [], sub: null}), value: null}],
				ret: TPath({name: 'Array', pack: [], params: [TPType(TPath({name: 'String', pack: [], params: [], sub: null}))], sub: null}),
				expr: {expr: EBlock(e), pos: p},
				params: []
			}
			
			return {name: 'getName', doc: null, meta: [], access: [AStatic, APublic], kind: FFun(f), pos: p}
		}
	}
	
	static function _makeTypeField(name, tid, gid, pos):Field
	{
		if (haxe.macro.Context.defined('display'))
		{
			return {name: name, doc: null, meta: [], access: [AStatic, APublic],
				kind: FVar(TPath({pack : [], name : 'Int', params : [], sub : null}), {expr: EConst(CInt('0')), pos: pos}), pos: pos}
		}
		else
		{
			var a = EBinop(OpShl, {expr: EConst(CInt('1')), pos: pos}, {expr: EConst(CInt(Std.string(tid))), pos: pos});
			var b = EBinop(OpShl, {expr: EConst(CInt(Std.string(gid))), pos: pos}, {expr: EConst(CInt(Std.string(NUM_EVENT_BITS))), pos: pos});
			var c = EBinop(OpOr, {expr: a, pos: pos}, {expr: b, pos: pos});
			return {name: name, doc: null, meta: [], access: [AStatic, APublic, AInline],
				kind: FVar(TPath({pack : [], name : 'Int', params : [], sub : null}), {expr: c, pos: pos}), pos: pos}
		}
	}
	
	static function _makeGroupIdField(gid, pos):Field
	{
		return {name: 'GROUP_ID', doc: null, meta: [], access: [AStatic, APublic, AInline],
			kind: FVar(TPath({pack : [], name : 'Int', params : [], sub : null}), {expr: EConst(CInt(Std.string(gid))), pos: pos}), pos: pos}
	}
	
	static function _makeGroupMaskField(gid, pos):Field
	{
		var mask = EBinop(OpShl, {expr: EConst(CInt(Std.string(gid))), pos: pos}, {expr: EConst(CInt(Std.string(NUM_EVENT_BITS))), pos: pos});
		
		return {name: 'GROUP_MASK', doc: null, meta: [], access: [AStatic, APublic, AInline],
			kind: FVar(TPath({pack : [], name : 'Int', params : [], sub : null}), {expr: mask, pos: pos}), pos: pos}
	}
	
	static function _makeEventMaskField(n, pos):Field
	{
		var mask = EBinop(OpSub,
			{expr: EBinop(OpShl, {expr: EConst(CInt('1')), pos: pos}, {expr: EConst(CInt(Std.string(n))), pos: pos}), pos: pos},
			{expr: EConst(CInt('1')), pos: pos});
		
		return {name: 'EVENT_MASK', doc: null, meta: [], access: [AStatic, APublic, AInline],
			kind: FVar(TPath({pack : [], name : 'Int', params : [], sub : null}), {expr: mask, pos: pos}), pos: pos}
	}
	#end
}