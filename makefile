16_x := x x x x x x x x x x x x x x x
16_t := t t t t t t t t t t t t t t t

input_int_x := $(foreach a,$(16_x),$(foreach b,$(16_x),$(foreach c,$(16_x),$(16_x))))
input_int_t := $(foreach a,$(16_t),$(foreach b,$(16_t),$(foreach c,$(16_t),$(16_t))))
encode = $(wordlist 1,$1,$(input_int_x))
decode = $(words $1)

add = $1 $2
inc = x $1
inc_2 = x x $1

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

sieve_size := 20
sieve_size_encode = $(call encode,$(sieve_size))
rawbits = $(call halve_t,$(wordlist 1,$(sieve_size),$(input_int_t)))

factor := x x x
next_factor :=
num := 

# $(eval $(num) := $(call encode,$(factor)))

# rawbits: represents a list of booleans. Half the size of sieve
# loop over rawbits
# loop from factor to half sieve size

run_sieve = $(foreach a,$(rawbits),\
				$(or \
					$(eval num := $(factor)),\
					$(info start factor $(call decode,$(factor))),\
					$(and \
						$(foreach b,$(wordlist $(call decode,$(factor)),$(call decode,$(rawbits)),$(sieve_size_encode)),\
							$(or \
								$(if $(and $(call not,$(next_factor)),$(filter t,$(word $(call decode,$(call halve_x,$(num))),$(rawbits)))),\
									$(or \
										$(eval next_factor := $(num)),\
										$(info found next factor $(next_factor))\
									)\
								),\
								$(eval num := $(call inc_2,$(num))),\
								$(info num $(call decode,$(num)) fac $(call decode,$(next_factor)))\
							)\
						),\
					),\
					$(eval factor := $(next_factor)),\
					$(eval next_factor :=),\
					$(eval factor := $(call inc_2,$(factor))),\
					$(info $(call decode,$(factor)))\
				)\
			)

# use word to get bit from rawbits
# input into word using decode
# use wordlist for range
# in for each, start with encoded factor, and inc each time

# all: ; @echo $(call decode,$(call halve,x x x x))
all: ; @echo $(call run_sieve)
# all: ; @echo $(call not,)
