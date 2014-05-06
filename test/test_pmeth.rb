#encoding: utf-8
require_relative '../lib/pmeth'
require 'test/unit'

class TestPMeth < Test::Unit::TestCase

	T1 = %w(a b c d e f g h i j k l m n o p q r s t) # 20
	T2 = T1[0..-2] # 19
	T3 = T1[0..5] # 6
	T4 = T1[0..6] # 7
	T5 = T1[0..4] # 5
	T6 = T1[0..3] # 4

	TEST_ARRAYS = [T1, T2, T3, T4, T5, T6]

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
			assert(chunk_mutant != t, "chunk_mutant#{x} was the same as parent")
			assert(chunk_mutant.sort == t.sort, "chunk_mutant#{x} not a permutation")
			x+=1
		end	
	end

	def test_swap_mutate
		x = 0
		TEST_ARRAYS.each do |t|
			swap_mutant = PMeth.swap_mutate(t)
			assert_kind_of(Array, swap_mutant, "swap_mutant#{x} not array")
			assert(swap_mutant.uniq == swap_mutant, "swap_mutant#{x} not unique")
			assert(swap_mutant != t, "swap_mutant#{x} same as non-mutant")
			assert(swap_mutant.sort == t.sort, "swap_mutant#{x} not a permutation")
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

