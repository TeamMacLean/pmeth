#encoding: utf-8
require 'pmeth'
require 'test/unit'

class TestPMeth < Test::Unit::TestCase

	TEST_ARRAY = %w(a b c d e f g h i j k l m n o p q r s t) # 20
	T2 = TEST_ARRAY[0..-2] # 19
	T3 = TEST_ARRAY[0..5] # 6

	def test_division
		ax = PMeth.division(TEST_ARRAY)
		assert(ax==1||ax==2||ax==4||ax==5||ax==10||ax==20, "length 20 array, division wrong, #{ax}")

		bx = PMeth.division(T2)
		assert(bx==1||bx==19, "length 19 array, division wrong, #{bx}")

		cx = PMeth.division(T3)
		assert(cx==1||cx==2||cx==3||cx==6, "length 6 array, division wrong, #{cx}")
	end

	# def test_recombination
	# 	ts = TEST_ARRAY.shuffle
	# 	child = PMeth.recombine(TEST_ARRAY, ts)
	# 	t2s = T2.shuffle
	# 	child2 = PMeth.recombine(T2, t2s)

	# 	assert(child.uniq == child, 'Child not unique')
	# 	assert(child != TEST_ARRAY, 'Child same as test array')
	# 	assert(child != ts, 'Child same as shuffled test array')
	# 	assert(child.sort == ts.sort, 'Child not a permutation')

	# 	assert(child2.uniq == child2, 'Child 2 not unique')
	# 	assert(child2 != T2, 'Child same as t2')
	# 	assert(child2 != t2s, 'Child same as shuffled t2')
	# 	assert(child2.sort == t2s.sort, 'Child 2 not a permutation')
	# end

	# def test_mutate
	# 	mutant = PMeth.mutate(TEST_ARRAY)
	# 	assert(mutant.uniq == mutant)
	# 	assert(mutant != TEST_ARRAY, 'Mutant was the same as parent')
	# 	assert_kind_of(Array, mutant, 'Mutant not an array!')
	# 	assert(mutant.sort == TEST_ARRAY.sort, 'Mutant not a permutation')	
	# end

	# def test_mini_mutate
	# 	mini_mutant = PMeth.mini_mutate(TEST_ARRAY)
	# 	assert(mini_mutant.uniq == mini_mutant)
	# 	assert(mini_mutant != TEST_ARRAY, "Mini-mutant same as non-mutant")
	# 	assert_kind_of(Array, mini_mutant)
	# 	assert(mini_mutant.sort == TEST_ARRAY.sort, 'Mini-mutant not a permutation')	
	# end
end

