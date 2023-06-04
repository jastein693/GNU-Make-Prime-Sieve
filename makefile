16_x := x x x x x x x x x x x x x x x
16_t := t t t t t t t t t t t t t t t

two := x x
three := x x x

input_int_x := $(foreach a,$(16_x),$(foreach b,$(16_x),$(foreach c,$(16_x),$(16_x))))
input_int_t := $(foreach a,$(16_t),$(foreach b,$(16_t),$(foreach c,$(16_t),$(16_t))))
encode = $(wordlist 1,$1,$(input_int_x))
decode = $(words $1)

add = $1 $2

inc = x $1

inc_2 = x x $1

multiply = $(foreach a,$1,$2)

max = $(subst xx,x,$(join $1,$2))

gt = $(filter-out $(words $2),$(words $(call max,$1,$2)))

eq = $(filter $(words $1),$(words $2))

ne = $(filter-out $(words $1),$(words $2))

gte = $(call gt,$1,$2)$(call eq,$1,$2)

subtract = $(if $(call gte,$1,$2),\
                $(filter-out xx,$(join $1,$2)),\
                $(warning Subtraction underflow))

divide = $(if $(call gte,$1,$2),\
			x $(call divide,$(call subtract,$1,$2),$2),)

halve_x = $(subst xx,x,\
			$(filter-out xy x y,\
				$(join $1,\
					$(foreach a,$1,y x))))

halve_t = $(subst tt,t,\
			$(filter-out ty t y,\
				$(join $1,\
					$(foreach a,$1,y t))))

test = $(join $1,y y)

not = $(if $(filter x,$1),,x)

sieve_size := 1000
sieve_size_encode = $(call encode,$(sieve_size))
rawbits := $(call halve_t,$(wordlist 1,$(sieve_size),$(input_int_t)))

factor := x x x
next_factor :=
num := 
max_num := $(call decode,$(sieve_size_encode))
half :=

# $(eval $(num) := $(call encode,$(factor)))

# rawbits: represents a list of booleans. Half the size of sieve
# loop over rawbits
# loop from factor to half sieve size

bit_is_true = $(filter t,$(word $(call decode,$(call inc,$(call halve_x,$1))),$(rawbits)))

run_sieve = $(foreach a,$(rawbits),\
				$(or \
					$(eval num := $(factor)),\
					$(eval next_factor := $(factor)),\
					$(call eq,$(factor),),\
					$(eval factor_found := f),\
					$(and \
						$(foreach b,$(wordlist $(call decode,$(factor)),$(sieve_size),$(sieve_size_encode)),\
							$(or \
								$(info looking for next factor. found := $(factor_found)),\
								$(filter $(factor_found),t),\
								$(info looking for next factor. num := $(call decode,$(num))),\
								$(info looking for next factor. num halve := $(call decode,$(call halve_x,$(num)))),\
								$(info looking for next factor. bits := $(rawbits)),\
								$(if $(call bit_is_true,$(num)),\
									$(or \
										$(eval next_factor := $(num)),\
										$(eval factor_found := t),\
									)\
								),\
								$(eval num := $(call inc_2,$(num))),\
							)\
						),\
					),\
					$(eval factor := $(next_factor)),\
					$(eval next_factor :=),\
					$(info factor $(call decode,$(factor))),\
					$(call eq,$(factor),),\
					$(eval num := $(call multiply,$(factor),$(three))),\
					$(and \
						$(foreach b,$(wordlist $(call decode,$(num)),$(max_num),$(sieve_size_encode)),\
							$(or \
								$(call gt,$(num),$(sieve_size_encode)),\
								$(info num $(call decode,$(num))),\
								$(eval half := $(call halve_x,$(num))),\
								$(eval rawbits := $(wordlist 1,$(call decode,$(half)),$(rawbits)) f $(wordlist $(call decode,$(call add,$(half),$(two))),$(call decode,$(rawbits)),$(rawbits))),\
								$(eval num := $(call add,$(num),$(call multiply,$(factor),$(two)))),\
							)\
						),\
					),\
					$(eval factor := $(call inc_2,$(factor))),\
				)\
			)

print_num := x x x
print_results = $(foreach a,$(rawbits),\
					$(or \
						$(and \
							$(if $(call bit_is_true,$(print_num)),\
								$(info result $(call decode,$(print_num)))\
							),\
						),\
						$(eval print_num := $(call inc_2,$(print_num))),\
					)\
				)

total_primes :=
count_primes =  $(and \
					$(foreach a,$(rawbits),\
						$(if $(filter t,$(a)),\
							$(eval total_primes := $(call inc,$(total_primes)))\
						),\
					),\
				)
# count_primes = $(foreach a,$(rawbits),\
# 					$(info a $(a))\
# 				)
# use word to get bit from rawbits
# input into word using decode
# use wordlist for range
# in for each, start with encoded factor, and inc each time

# word returns size of list
# wordlist retuns substring start,end,list

# all: ; @echo $(call decode,$(call halve,x x x x))
all: ; @echo $(and $(run_sieve),$(count_primes)) total $(call decode,$(total_primes))
# all: ; @echo $(call not,)

# all: ; @echo $(call divide,x x x x x x x x x x x x x x x x x x x x x,x x x x x x)

# $(and \
# 						$(foreach b,\
						
# 						),\
# 					),\



