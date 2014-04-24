#encoding: utf-8
class PMeth
	# Input: An integer you wish to know whether is prime
	# Output: true/false
	def self.prime?(n)
		for d in 2..(n - 1)
			if (n % d) == 0
	    		return false
	    	end
		end
		true
	end

	# Input: A permutation array of unique objects
	# Output: A random integer that the length of the Input 0 array can be divided by to get another integer (the randomly chosen size of chunks that permutations will be split into, in the recombine/mutate methods)
	def self.division(objects) #number of objects must be => 10
		x = 1.5
		until objects.length/x == (objects.length/x).to_i && x <= objects.length
			x = (objects.length/10).to_f + rand(objects.length).to_f
		end
		return x
	end

	# Input 0: A parent permutation array of unique objects
	# Input 1: A second parent permutation array of the same unique objects as input 0
	# Output: A child permutation array, whose order is a recombination of the parent permutations (the same unique objects ordered differently to either input)
	def self.recombine(a_parent, b_parent)
		kid = []
		1.times do # so we can use redo
			x = division(a_parent)
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

	# Input: A permutation array of unique objects
	# Output: A slightly different permutation array of the same unique objects
	def self.mutate(fasta)
		mutant = []
		1.times do
			x = 0
			until x > 2
				x = division(fasta)
			end
			sliced = fasta.each_slice(x).to_a
			e = rand(sliced.length-1).to_i
			sliced[e] = sliced[e].shuffle
			if sliced.flatten == fasta
				redo
			end
			mutant << sliced.flatten
		end
		return mutant[0]
	end

	# Input: A permutation array of unique objects
	# Output: A slightly different permutation array of the same unique objects
	def self.mini_mutate(fasta)
		a = b = 0
		until a != b
			a = fasta[rand(fasta.length-1)]
			b = fasta[rand(fasta.length-1)]
		end
		mutant = []
		fasta.each do |i|
			if i == a
				mutant << b
			elsif i == b
				mutant << a
			else
				mutant << i
			end
		end
		return mutant
	end
end