#encoding: utf-8
require_relative '../lib/pmeth'
require 'test/unit'

class TestPMeth < Test::Unit::TestCase

	def setup
		@t1 = (1..20).to_a
		@t2 = (1..19).to_a
		@t3 = (1..6).to_a
		@t4 = (1..53).to_a
		@test_arrays = [@t1, @t2, @t3, @t4]
	end
  
	def test_division
		x1 = PMeth.division(@t1)
		assert(x1==1||x1==2||x1==4||x1==5||x1==10, "length 20 array, division wrong, #{x1}")

		x2 = PMeth.division(@t2)
		assert(x2==1, "length 19 array, division wrong, #{x2}")

		x3 = PMeth.division(@t3)
		assert(x3==1||x3==2||x3==3, "length 6 array, division wrong, #{x3}")
	end


	def test_methods
    		@test_arrays.each_with_index do |t,i|
	     		[[PMeth.chunk_mutate(t.dup), :chunk_mutant], [PMeth.swap_mutate(t), :swap_mutant], [PMeth.recombine(t, t.shuffle), :child]].each do |list, method|
		    		assert_kind_of(Array, list, "#{method} #{i} not an array!")
				assert(list.uniq == list, "#{method} #{i} not unique")
				assert(t != list, "#{method} #{i} was the same as parent")
				assert(t.sort == list.sort, "#{method} #{i} not a permutation")
				assert(t.length == list.length, "#{method} #{i} wrong length")
	    		end
		end
	end
end

