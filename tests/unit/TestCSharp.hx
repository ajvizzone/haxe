package unit;
import haxe.Int32;
using haxe.Int32;

//C#-specific tests, like unsafe code
class TestCSharp extends Test 
{
	#if cs
	
	@:skipReflection private function refTest(i:cs.Ref<Int>):Void
	{
		i *= 2;
	}
	
	@:skipReflection private function outTest(out:cs.Out<Int>, x:Int):Void
	{
		out = x * 2;
	}
	
	public function testRef()
	{
		var i = 10;
		refTest(i);
		eq(i, 20);
	}
	
	public function testOut()
	{
		var i = 0;
		outTest(i, 10);
		eq(i, 20);
	}
	
	#if unsafe
	
	@:unsafe public function testUnsafe()
	{
		var x:cs.NativeArray<Int> = new cs.NativeArray(10);
		var p;
		cs.Lib.fixed(p = cs.Lib.pointerOfArray(x),
		{
			for (i in 0...10)
			{
				p[0] = i;
				p++;
			}
		});
		
		cs.Lib.fixed(p = cs.Lib.pointerOfArray(x),
		{
			for (i in 0...10)
			{
				eq(p[i], i);
			}
		});
		
		var x:Int = 0;
		var addr = cs.Lib.addressOf(x);
		eq(cs.Lib.valueOf(addr), 0);
		eq(addr[0], 0);
		x[0] = 42;
		eq(cs.Lib.valueOf(addr), 42);
		eq(addr[0], 42);
		eq(x, 42);
		
		
	}
	
	#end
	
	#end
}