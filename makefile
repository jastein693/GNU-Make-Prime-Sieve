include gmsl/gmsl

two := x x
three := x x x

inc_2 = $(two) $1

sieve_size := 9000
sieve_size_encode := $(call int_encode,$(sieve_size))
rawbits := $(call int_halve,$(sieve_size_encode))

factor := $(three)

bit_is_true = $(filter x,$(word $(call int_decode,$(call int_inc,$(call int_halve,$1))),$(rawbits)))

find_factor =	$(if $(call bit_is_true,$(num)),\
					$(info num1 $(call int_decode,$(num)))\
					$(eval factor := $(num)),\
					$(eval num := $(call inc_2,$(num)))\
					$(call find_factor)\
				)

clear_bits =	$(if $(call int_gt,$(num),$(sieve_size_encode)),,\
					$(info num2 $(call int_decode,$(num)))\
					$(eval half := $(call int_halve,$(num)))\
					$(info num3 $(call int_decode,$(num)))\
					$(eval rawbits := $(wordlist 1,$(call int_decode,$(half)),$(rawbits)) f $(wordlist $(call int_decode,$(call int_plus,$(half),$(two))),$(call int_decode,$(rawbits)),$(rawbits)))\
					$(info num4 $(call int_decode,$(num)))\
					$(eval num := $(call int_plus,$(num),$(call int_multiply,$(factor),$(two))))\
					$(info num5 $(call int_decode,$(num)))\
					$(call clear_bits)\
			  	)

odd_number := x
sub := $(sieve_size_encode)

run_sieve = $(if $(call int_eq,$(sub),),,\
				$(eval sub := $(call int_subtract,$(sub),$(odd_number)))\
				$(eval odd_number += $(two))\
				$(eval num := $(factor))\
				$(call find_factor)\
				$(eval num := $(call int_multiply,$(factor),$(three)))\
				$(call clear_bits)\
				$(info clear bits done)\
				$(eval factor := $(call inc_2,$(factor)))\
				$(info !!!!!!!!!!)\
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