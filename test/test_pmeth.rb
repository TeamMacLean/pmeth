#encoding: utf-8
require_relative '../lib/pmeth'
require 'test/unit'

class TestPMeth < Test::Unit::TestCase

	T1 = (1..20).to_a
	T2 = (1..19).to_a
	T3 = (1..6).to_a
	T4 = (1..53).to_a

	TEST_ARRAYS = [T1, T2, T3, T4]

	def test_division
		x1 = PMeth.division(T1)
		assert(x1==1||x1==2||x1==4||x1==5||x1==10, "length 20 array, division wrong, #{x1}")

		x2 = PMeth.division(T2)
		assert(x2==1, "length 19 array, division wrong, #{x2}")

		x3 = PMeth.division(T3)
		assert(x3==1||x3==2||x3==3, "length 6 array, division wrong, #{x3}")
	end

	def test_chunk_mutate
		x = 0
		TEST_ARRAYS.each do |t|
			chunk_mutant = PMeth.chunk_mutate(t.dup)
			assert_kind_of(Array, chunk_mutant, "chunk_mutant#{x} not an array!")
			assert(chunk_mutant.uniq == chunk_mutant, "chunk_mutant#{x} not unique")
			assert(t != chunk_mutant, "chunk_mutant#{x} was the same as parent")
			assert(t.sort == chunk_mutant.sort, "chunk_mutant#{x} not a permutation")
			assert(t.length == chunk_mutant.length, "chunk_mutant#{x} wrong length")
			x+=1
		end	
	end

	def test_swap_mutate
		x = 0
		TEST_ARRAYS.each do |t|
			swap_mutant = PMeth.swap_mutate(t)
			assert_kind_of(Array, swap_mutant, "swap_mutant#{x} not array")
			assert(swap_mutant.uniq == swap_mutant, "swap_mutant#{x} not unique")
			assert(t != swap_mutant, "swap_mutant#{x} same as non-mutant")
			assert(t.sort == swap_mutant.sort, "swap_mutant#{x} not a permutation")
			assert(t.length == swap_mutant.length, "swap_mutant#{x} wrong length")
			x+=1
		end
	end

	def test_recombine
		x = 0
		TEST_ARRAYS.each do |t|
			ts = t.shuffle
			child = PMeth.recombine(t, ts)
			assert_kind_of(Array, child, "Child#{x} not array")
			assert(child.uniq == child, "Child#{x} not unique")
			assert(child != t, "Child#{x} same as test array")
			assert(child != ts, "Child#{x} same as shuffled test array")
			assert(child.sort == ts.sort, "Child#{x} not a permutation")
			x+=1
		end
	end
end

