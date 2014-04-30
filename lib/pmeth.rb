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

	# Returns a random integer that array can be divided by to get another integer (other than the array length itself)
	def self.division(array)
		x = 1.5 # x assigned a non-integer value to begin with
		if prime?(array.length) # array with prime number of objects is not divisible by any integer other than 1 and itself
			x = 1
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

	# Returns a permutation whose objects are ordered partly like a_parent permutation, and partly like b_parent permutation
	def self.recombine(a_parent, b_parent)
		child_permutation = []
		1.times do # this is to make use of the redo statement below
			x = division(a_parent) # the randomly chosen size of chunks that permutations will be split into
			if prime?(a_parent.length) # to compensate for permutations with a prime number of objects:
				ig = rand(a_parent.length)-1 # choose a random object to ignore - to add back at its original index after mutation
				a_parent_reduced, b_parent_reduced = a_parent.dup, b_parent.dup # then create duplicates of the parent arrays...
				a_parent_reduced.delete_at(ig); b_parent_reduced.delete_at(ig) # .. and remove the ignored object from these duplicates
				x = division(a_parent_reduced) # choose a new chunk size for reduced parent permutations, that no longer have a prime number of objects
				a_parent_sliced = a_parent_reduced.each_slice(x).to_a # slice the reduced parent permutations into chunks of size x
				b_parent_sliced = b_parent_reduced.each_slice(x).to_a
			else
				a_parent_sliced = a_parent.each_slice(x).to_a # if permutation lengths are non-prime, just slice the parent permutations into chunks of size x
				b_parent_sliced = b_parent.each_slice(x).to_a
			end
			chosen = rand(b_parent_sliced.length)-1 # choose a chunk to have b_parent ordered objects in child permutation
			child = a_parent_sliced.flatten.dup # un-modified child permutation to accept chunk from b_parent (and possibly ignored object)
			a_indices = []
			### place each object in chosen a_parent chunk into the index it's corresponding object (from b_parent) occupies in a_parent ###
			a_parent_sliced[chosen].each do |i| 
				index = a_parent_sliced[chosen].index(i) # the index of each object in the chosen a_parent chunk...
				b_object = b_parent_sliced[chosen][index] # ... the object at that index in the chosen b_parent chunk...
				a_indices << a_parent_sliced.flatten.index(b_object) # ... the index of that object (from b_parent chunk) (INDEX RHO) in a_parent is added to an array
			end
			if a_indices.include?(nil) # TODO unsure why: a_indices sometimes includes nil
				redo
			else
				y = 0
				a_indices.each do |ai|
					unless b_parent_sliced[chosen].include?(a_parent_sliced[chosen][y]) # unless the chosen chunk from b_parent includes objects from the chosen a_parent chunk...
						child[ai] = a_parent_sliced[chosen][y] # ... the object from the chosen chunk in parent_a is added to INDEX RHO in child
						chosen_index = a_parent_sliced.flatten.index(a_parent_sliced[chosen][y]) # index of object from a_parent's chosen chunk in a_parent
						child[chosen_index] = b_parent_sliced[chosen][y] # swapping the indices of objects in chunks from parents, to give their indices in child
					end
					y+=1
				end
			end
			if ig != nil # if the permutations are a prime number in length, we now add the ignored object from earlier into child
				if b_parent_sliced[chosen].include?(b_parent[ig]) # add the ignored object from b_parent if it's in the chosen chunk...
					child.insert(ig, b_parent[ig])
				else
					child.insert(ig, a_parent[ig]) # ...otherwise add the ignored object from a_parent
				end
			end
			child_permutation << child # so we can access this outside the loop
		end
		return child_permutation[0]
	end

end