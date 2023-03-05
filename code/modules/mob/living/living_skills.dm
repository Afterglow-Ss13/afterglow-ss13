
/mob
	var/skill_guns = 100
	var/skill_energy = 100
	var/skill_unarmed = 100
	var/skill_melee = 100
	var/skill_throwing = 100
	var/skill_first_aid = 100
	var/skill_doctor = 100
	var/skill_sneak = 100
	var/skill_lockpick = 100
	var/skill_traps = 100
	var/skill_science = 100
	var/skill_repair = 100
	var/skill_speech = 100
	var/skill_barter = 100
	var/skill_outdoorsman = 100
	var/sneaking = FALSE

// -20 for an easy roll
// -10 for difficulty on a 'normal' roll
// 0 for a challenging roll
// +20 for an expert roll
/mob/proc/skill_roll(check, difficulty = DIFFICULTY_NORMAL)
	return ((skill_value(check) + special_l) >= (rand(1,100) + difficulty))

/mob/proc/skill_roll_under(check, difficulty = DIFFICULTY_NORMAL)
	return  ((rand(1,100) + difficulty) - (skill_value(check)))

/mob/proc/skill_check(check, threshold = REGULAR_CHECK)
	return (skill_value(check) >= threshold)

/mob/proc/skill_value(check)
	if (SKILL_GUNS == check)
		return skill_guns + special_a
	if (SKILL_ENERGY == check)
		return skill_energy + special_a
	if (SKILL_UNARMED == check)
		return skill_unarmed + round((special_a + special_s)/2)
	if (SKILL_MELEE == check)
		return skill_melee + round((special_a + special_s)/2)
	if (SKILL_THROWING == check)
		return skill_throwing + special_a
	if (SKILL_FIRST_AID == check)
		return skill_first_aid + round((special_p*2 + special_i)/2)
	if (SKILL_DOCTOR == check)
		return skill_doctor + round((special_p*2 + special_i)/2)
	if (SKILL_SNEAK == check)
		return skill_sneak + special_a
	if (SKILL_LOCKPICK == check)
		return skill_lockpick + round((special_p*2 + special_a)/2)
	if (SKILL_TRAPS == check)
		return skill_traps + round((special_p*2 + special_a)/2)
	if (SKILL_SCIENCE == check)
		return skill_science + (special_i * 2)
	if (SKILL_REPAIR == check)
		return skill_repair + special_i
	if (SKILL_SPEECH == check)
		return skill_speech + (special_c * 2)
	if (SKILL_BARTER == check)
		return skill_barter + (special_c * 2)
	if (SKILL_OUTDOORSMAN == check)
		return skill_outdoorsman + round((special_i + special_e)/2)
	return 0


/mob/proc/update_skill_value(skill, value)
	if (SKILL_GUNS == skill)
		skill_guns = value
	if (SKILL_ENERGY == skill)
		skill_energy = value
	if (SKILL_UNARMED == skill)
		skill_unarmed = value
	if (SKILL_MELEE == skill)
		skill_melee = value
	if (SKILL_THROWING == skill)
		skill_throwing = value
	if (SKILL_FIRST_AID == skill)
		skill_first_aid = value
	if (SKILL_DOCTOR == skill)
		skill_doctor = value
	if (SKILL_SNEAK == skill)
		skill_sneak = value
	if (SKILL_LOCKPICK == skill)
		skill_lockpick = value
	if (SKILL_TRAPS == skill)
		skill_traps = value
	if (SKILL_SCIENCE == skill)
		skill_science = value
	if (SKILL_REPAIR == skill)
		skill_repair = value
	if (SKILL_SPEECH == skill)
		skill_speech = value
	if (SKILL_BARTER == skill)
		skill_barter = value
	if (SKILL_OUTDOORSMAN == skill)
		skill_outdoorsman = value
	invalidate_skill_caches()
	
/mob/proc/invalidate_skill_caches()
	cached_knowable_recipies = list()
	cached_unknowable_recipies = list()

/mob/living/verb/try_to_talk_to(atom/A as mob in view())
	set name = "Talk to"
	set category = "IC"

	var/mob/m = A
	if(!(A in view(client ? client.view : world.view, src)) || !m.will_talk)
		// shift-click catcher may issue examinate() calls for out-of-sight turfs
		return
	
	m.talk_to(src)


/mob/living/verb/sneak()
	set name = "Sneak"
	set category = "IC"
	if (!sneaking)
		start_sneaking()
	else
		stop_sneaking()

/mob/living/proc/start_sneaking()
	if (!sneaking)
		sneaking = TRUE
		src.alpha = (255 - (src.skill_value(SKILL_SNEAK) * 2))
		to_chat(src, span_notice("You start sneaking."))
		if (m_intent != MOVE_INTENT_WALK)
			toggle_move_intent()
		

/mob/living/proc/stop_sneaking()
	if (sneaking)
		sneaking = FALSE
		src.alpha = 255
		to_chat(src, span_warning("You stop sneaking."))
