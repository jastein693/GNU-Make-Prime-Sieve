16_x := x x x x x x x x x x x x x x x

two := x x
three := x x x

input_int_x := $(foreach a,$(16_x),$(foreach b,$(16_x),$(foreach c,$(16_x),$(16_x))))
encode = $(wordlist 1,$1,$(input_int_x))
decode = $(words $1)

add = $1 $2

inc = x $1

inc_2 = x x $1

multiply = $(foreach a,$1,$2)

max = $(subst xx,x,$(join $1,$2))

gt = $(filter-out $(words $2),$(words $(call max,$1,$2)))

eq = $(filter $(words $1),$(words $2))

halve = $(subst xx,x,\
			$(filter-out xy x y,\
				$(join $1,\
					$(foreach a,$1,y x))))

test = $(join $1,y y)

not = $(if $(filter x,$1),,x)

sieve_size := 10000
sieve_size_encode = $(call encode,$(sieve_size))
rawbits := $(call halve,$(wordlist 1,$(sieve_size),$(input_int_x)))

factor := $(three)
max_num := $(call decode,$(sieve_size_encode))

bit_is_true = $(filter x,$(word $(call decode,$(call inc,$(call halve,$1))),$(rawbits)))

run_sieve = $(foreach a,$(rawbits),\
				$(or \
					$(eval num := $(factor)),\
					$(eval next_factor := $(factor)),\
					$(call eq,$(factor),),\
					$(eval factor_found := f),\
					$(and \
						$(foreach b,$(wordlist $(call decode,$(factor)),$(sieve_size),$(sieve_size_encode)),\
							$(or \
								$(filter $(factor_found),t),\
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
					$(call eq,$(factor),),\
					$(eval num := $(call multiply,$(factor),$(three))),\
					$(and \
						$(foreach b,$(wordlist $(call decode,$(num)),$(max_num),$(sieve_size_encode)),\
							$(or \
								$(call gt,$(num),$(sieve_size_encode)),\
								$(eval half := $(call halve,$(num))),\
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
						$(if $(filter x,$(a)),\
							$(eval total_primes := $(call inc,$(total_primes)))\
						),\
					),\
				)

all: ; @echo $(and $(run_sieve),$(count_primes)) total $(call decode,$(total_primes))
