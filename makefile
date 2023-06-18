include gmsl/gmsl

two := x x
three := x x x

inc_2 = $(two) $1

sieve_size := 1000
sieve_size_encode := $(call int_encode,$(sieve_size))
sieve_size_half := $(call int_decode,$(call int_halve,$(sieve_size_encode)))
rawbits := $(call int_halve,$(sieve_size_encode))

factor := $(three)

bit_is_true = $(filter x,$(word $(call int_decode,$(call int_inc,$(call int_halve,$1))),$(rawbits)))

# ITERATE = $(eval ITERATE_COUNT :=)\
# $(if $(filter ${1},0),,\
#   $(call ITERATE_DO,${1},${2})\
# )

# ITERATE_DO = $(if $(word ${1}, ${ITERATE_COUNT}),,\
#   $(eval ITERATE_COUNT+=.)\
#   $(info ${2} $(words ${ITERATE_COUNT}))\
#   $(call ITERATE_DO,${1},${2})\
# )

odd_number := x
sub := $(sieve_size_encode)

# run_sieve =	$(if $(filter ${sieve_size},0),,\
# 				$(call sqrt_do,${1},${2})\
# 			)

run_sieve = $(if $(call int_eq,$(sub),),,\
				$(eval sub := $(call int_subtract,$(sub),$(odd_number)))\
				$(eval odd_number += $(two))\
				$(or \
					$(eval num := $(factor)),\
					$(eval next_factor := $(factor)),\
					$(call int_eq,$(factor),),\
					$(eval factor_found := f),\
					$(and \
						$(foreach b,$(wordlist $(call int_decode,$(factor)),$(sieve_size_half),$(sieve_size_encode)),\
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
					$(call int_eq,$(factor),),\
					$(eval num := $(call int_multiply,$(factor),$(three))),\
					$(eval max := $(call int_inc,$(call int_divide,$(call int_subtract,$(sieve_size_encode),$(num)),$(call int_multiply,$(factor),$(two))))),\
					$(and \
						$(foreach b,$(wordlist 1,$(call int_decode,$(max)),$(sieve_size_encode)),\
							$(or \
								$(call int_gt,$(num),$(sieve_size_encode)),\
								$(eval half := $(call int_halve,$(num))),\
								$(eval rawbits := $(wordlist 1,$(call int_decode,$(half)),$(rawbits)) f $(wordlist $(call int_decode,$(call int_plus,$(half),$(two))),$(call int_decode,$(rawbits)),$(rawbits))),\
								$(eval num := $(call int_plus,$(num),$(call int_multiply,$(factor),$(two)))),\
							)\
						),\
					),\
					$(eval factor := $(call inc_2,$(factor))),\
				)\
				$(call run_sieve)\
			)

print_num := $(three)
results := 2
print_results = $(foreach a,$(rawbits),\
					$(or \
						$(and \
							$(if $(call bit_is_true,$(print_num)),\
								$(eval results := $(results), $(call int_decode,$(print_num)))\
							),\
						),\
						$(eval print_num := $(call inc_2,$(print_num))),\
					)\
				)

total_primes :=
count_primes =  $(and \
					$(foreach a,$(rawbits),\
						$(if $(filter x,$(a)),\
							$(eval total_primes := $(call int_inc,$(total_primes)))\
						),\
					),\
				)

all: ; @echo $(run_sieve) $(count_primes) total $(call int_decode,$(total_primes))
# all: ; @echo $(run_sieve) $(count_primes) total $(call int_decode,$(total_primes)) $(print_results) $(results)
# all: ; @echo $(call ITERATE,5,$(info test))
# all: ; @echo $(run_sieve)


# $(eval max := $(call int_divide,$(call int_subtract,$(sieve_size_encode),$(num)),$(call int_multiply,$(factor),$(two)))),\
# $(info num $(call int_decode,$(num))),\
# 					$(info sub $(call int_decode,$(call int_subtract,$(sieve_size_encode),$(num)))),\