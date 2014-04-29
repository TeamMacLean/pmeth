#encoding: utf-8
class PMeth
	# Returns true if n is a prime number, false if not
	def self.prime?(n)
		for d in 2..(n - 1)
			if (n % d) == 0
				return false
			end
		end
		true
	end

	# Returns a random integer that array can be divided by to get another integer
	def self.division(array)
		x = 1.5 # x assigned a non-integer value to begin with
		if prime?(array.length) # array with prime number of objects is not divisible by any integer other than itself
			x = array.length
		else
			until x > 0 && array.length/x.to_f == (array.length/x.to_f).to_i && Integer === x
				x = rand(array.length)
			end
		end
		return x
	end

	# Returns a new permutation that has had a randomly sized sub-section re-ordered by shuffle
	def self.chunk_mutate(permutation)
		if prime?(permutation.length) # if there are a prime number of objects in the permutation
			ig = rand(permutation.length)-1 # choose a random object to ignore - to add back at its original index after mutation
			ig_obj = permutation[ig] # save the object
			permutation.delete_at(ig)
		end
		mutant = []
		1.times do # this is to make use of the redo statement below
			x = 0 # x is the randomly chosen size of chunks that permutation will be split into
			until x > 2 # the chunk to be re-ordered must have at least 2 objects
				x = division(permutation)
			end
			sliced = permutation.each_slice(x).to_a # permutation is sliced into chunks of size x
			e = rand(sliced.length-1) # one of the chunks is chosen at random...
			sliced[e] = sliced[e].shuffle # ... and the objects within are shuffled
			new_perm = sliced.flatten
			if new_perm == permutation # if the size of the chunk to be shuffled is small, there is a chance that it may not be differently ordered by shuffle...
				redo # ... redo is used to ensure that a mutant permutation is created
			end
			if ig != nil
				new_perm.insert(ig, ig_obj)
			end
			mutant << new_perm # the new permutation has been added to an array for access outside the 1.times loop
		end
		return mutant[0] # new_perm
	end

	# Returns a new permutation where two of the objects have swapped positions (indices)
	def self.swap_mutate(permutation)
		a = b = x = y = 0
		until a != b
			x = rand(permutation.length-1) # randomly choose two indices x and y...
			y = rand(permutation.length-1)
			a = permutation[x] # ... and call the objects at these indices a and b
			b = permutation[y]
		end
		mutant = permutation.dup # create a new permutation...
		mutant[x] = b # ... with object b at index x...
		mutant[y] = a # ... and object a at index y
		return mutant
	end

	# Returns a permutation whose objects are ordered partly like a_parent and partly like b_parent
	def self.recombine(a_parent, b_parent)
		kid = []
		1.times do  # this is to make use of the redo statement below
			x = division(a_parent) # the randomly chosen size of chunks that permutations will be split into
			if x == a_parent.length && prime?(x) == false # If a permutation with a non-prime number of objects comes up with x == array length, redo
				redo
			elsif x == a_parent.length # to compensate for permutations with a prime number of objects:
				ig = rand(a_parent.length)-1 # choose a random element of the array to ignore - we add the object at this element back at its original position after recombination
				a_parent_reduced = a_parent.dup
				b_parent_reduced = b_parent.dup
				a_parent_reduced.delete_at(ig)
				b_parent_reduced.delete_at(ig)
				x = division(a_parent_reduced)
				a_parent_sliced = a_parent_reduced.each_slice(x).to_a
				b_parent_sliced = b_parent_reduced.each_slice(x).to_a
			else
				a_parent_sliced = a_parent.each_slice(x).to_a
				b_parent_sliced = b_parent.each_slice(x).to_a
			end
			chosen = rand(b_parent_sliced.length)-1 # choose one of the chunks (sub array from a permutation) to keep from b_parent
			child = a_parent_sliced.flatten.dup
			y = 0
			pos_array = []
			a_parent_sliced[chosen].each do |object| # place each object in the equivalent a_parent chunk into the position it's corresponding object (from b_parent) occupies in a_parent
				chunk = b_parent_sliced[chosen][y] # the equivalent object in the chosen b_parent chunk
				pos = a_parent_sliced.flatten.index(chunk) # the position of the b_parent chunk in a_parent
				c_pos = a_parent_sliced.flatten.index(object) # the position of the object in a_parent
				pos_array << pos
				y+=1
			end
			if pos_array.include?(nil)
				redo
			else
				y = 0
				pos_array.each do |pos|
					unless b_parent_sliced[chosen].include?(a_parent_sliced[chosen][y])
						child[pos] = a_parent_sliced[chosen][y]
						child[a_parent_sliced.flatten.index(a_parent_sliced[chosen][y])] = b_parent_sliced[chosen][y] # swapping the positions of objects in chunks from parents, to give their positions in child
					end
					y+=1
				end
			end
			if ig != nil
				if b_parent_sliced[chosen].include?(b_parent[ig]) # add the ignored object from b_parent if it's in the chosen chunk...
					child.insert(ig, b_parent[ig])
				else
					child.insert(ig, a_parent[ig]) # ...otherwise add the ignored object from a_parent
				end
			end
			if child != child.uniq
				redo
			end
			kid << child # so we can access this outside the loop
		end
		return kid[0]
	end

end