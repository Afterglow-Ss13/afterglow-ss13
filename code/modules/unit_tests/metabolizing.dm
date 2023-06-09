/datum/unit_test/metabolization/Run()
	// Pause natural mob life so it can be handled entirely by the test
	SSmobs.pause()

	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)

	for (var/reagent_type in subtypesof(/datum/reagent))
		test_reagent(human, reagent_type)

/datum/unit_test/metabolization/proc/test_reagent(mob/living/carbon/C, reagent_type)
	C.reagents.add_reagent(reagent_type, 10)
	C.reagents.metabolize(C, can_overdose = TRUE)
	C.reagents.clear_reagents()

/datum/unit_test/metabolization/Destroy()
	SSmobs.ignite()
	return ..()

/datum/unit_test/on_mob_end_metabolize/Run()
	// Same purpose as previous test.
	SSmobs.pause()
	
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/item/reagent_containers/pill/pill = allocate(/obj/item/reagent_containers/pill)
	var/datum/reagent/medicine/stimulants/stim = /datum/reagent/medicine/stimulants

	// Give them enough meth to be consumed in 2 metabolizations
	pill.reagents.add_reagent(stim, initial(stim.metabolization_rate) * 1.9)
	pill.attack(user, user)

	user.Life()

	TEST_ASSERT(user.reagents.has_reagent(stim), "User does not have meth in their system after consuming it")
	TEST_ASSERT(user.has_movespeed_modifier(/datum/movespeed_modifier/reagent/stimulants), "User consumed meth, but did not gain movespeed modifier")

	user.Life()

	TEST_ASSERT(!user.reagents.has_reagent(stim), "User still has meth in their system when it should've finished metabolizing")
	TEST_ASSERT(!user.has_movespeed_modifier(/datum/movespeed_modifier/reagent/stimulants), "User still has movespeed modifier despite not containing any more meth")
	
/datum/unit_test/on_mob_end_metabolize/Destroy()
	SSmobs.ignite()
	return ..()
