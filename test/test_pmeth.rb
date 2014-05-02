#encoding: utf-8
require_relative '../lib/pmeth'
require 'test/unit'

class TestPMeth < Test::Unit::TestCase

	TEST_ARRAY = %w(a b c d e f g h i j k l m n o p q r s t) # 20
	T2 = TEST_ARRAY[0..-2] # 19
	T3 = TEST_ARRAY[0..5] # 6

	def test_division
		ax = PMeth.division(TEST_ARRAY)
		assert(ax==1||ax==2||ax==4||ax==5||ax==10, "length 20 array, division wrong, #{ax}")

		bx = PMeth.division(T2)
		assert(bx==1, "length 19 array, division wrong, #{bx}")

		cx = PMeth.division(T3)
		assert(cx==1||cx==2||cx==3, "length 6 array, division wrong, #{cx}")
	end

	def test_chunk_mutate
		chunk_mutant = PMeth.chunk_mutate(TEST_ARRAY)
		assert_kind_of(Array, chunk_mutant, 'chunk_mutant not an array!')
		assert(chunk_mutant.uniq == chunk_mutant, 'chunk_mutant not unique')
		assert(chunk_mutant != TEST_ARRAY, 'chunk_mutant was the same as parent')
		assert(chunk_mutant.sort == TEST_ARRAY.sort, 'chunk_mutant not a permutation')

		chunk_mutant2 = PMeth.chunk_mutate(T2.dup)
		assert_kind_of(Array, chunk_mutant2, 'chunk_mutant2 not an array!')
		assert(chunk_mutant2.uniq == chunk_mutant2, 'chunk_mutant2 not unique')
		assert(chunk_mutant2 != T2, 'chunk_mutant2 was the same as parent')
		assert(chunk_mutant2.sort == T2.sort, 'chunk_mutant2 not a permutation')		
	end

	def test_swap_mutate
		swap_mutant = PMeth.swap_mutate(TEST_ARRAY)
		assert_kind_of(Array, swap_mutant, 'swap_mutant not array')
		assert(swap_mutant.uniq == swap_mutant, 'swap_mutant not unique')
		assert(swap_mutant != TEST_ARRAY, 'swap_mutant same as non-mutant')
		assert(swap_mutant.sort == TEST_ARRAY.sort, 'swap_mutant not a permutation')

		swap_mutant2 = PMeth.swap_mutate(T2)
		assert_kind_of(Array, swap_mutant2, 'swap_mutant2 not array')
		assert(swap_mutant2.uniq == swap_mutant2)
		assert(swap_mutant2 != T2, 'swap_mutant2 same as non-mutant')
		assert(swap_mutant2.sort == T2.sort, 'swap_mutant2 not a permutation')
	end

	def test_recombination
		ts = TEST_ARRAY.shuffle
		child = PMeth.recombine(TEST_ARRAY, ts)
		assert_kind_of(Array, child, 'Child not array')
		assert(child.uniq == child, 'Child not unique')
		assert(child != TEST_ARRAY, 'Child same as test array')
		assert(child != ts, 'Child same as shuffled test array')
		assert(child.sort == ts.sort, 'Child not a permutation')

		t2s = T2.shuffle
		child2 = PMeth.recombine(T2, t2s)
		assert_kind_of(Array, child2, 'Child 2 not array')
		assert(child2.uniq == child2, 'Child 2 not unique')
		assert(child2 != T2, 'Child same as t2')
		assert(child2 != t2s, 'Child same as shuffled t2')
		assert(child2.sort == t2s.sort, 'Child 2 not a permutation')
	end
end

