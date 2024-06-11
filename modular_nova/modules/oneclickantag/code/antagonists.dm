#define CATEGORY_ROUNDSTART "roundstarts"
#define CATEGORY_MIDROUND "midrounds"
#define CATEGORY_GHOTSROLE "ghostroles"

/datum/oneclickantag/antagonist_spawner
	var/antagonist_name
	var/category
	var/max_amount = 10

/datum/oneclickantag/antagonist_spawner/proc/create_antags(amount)
	return 0

/datum/oneclickantag/antagonist_spawner/proc/make_into_antag(list/targets)
	return FALSE

/datum/oneclickantag/antagonist_spawner/on_station
	category = CATEGORY_ROUNDSTART
	var/antagonist_datum
	var/allowed_antagonist
	var/list/excluded_roles

/datum/oneclickantag/antagonist_spawner/on_station/create_antags(amount)
	var/list/mob/living/candidates = GLOB.alive_player_list.Copy()

	for (var/mob/candidate in candidates)
		if(isnull(candidate.client) || isnull(candidate.mind))
			candidates.Remove(candidate)
			continue
		if(!candidate.client.prefs.read_preference(/datum/preference/toggle/be_antag))
			candidates.Remove(candidate)
			continue
		if(is_banned_from(candidate.ckey, BAN_ANTAGONIST) || is_banned_from(candidate.ckey, antagonist_name))
			candidates.Remove(candidate)
			continue
		if(!(antagonist_name in candidate.client.prefs.be_special))
			candidates.Remove(candidate)
			continue
		if (!(candidate.mind.assigned_role.job_flags & JOB_CREW_MEMBER))
			candidates.Remove(candidates)
			continue
		if (candidate.mind.assigned_role in excluded_roles)
			candidates.Remove(candidates)
			continue
		if(candidate.mind.antag_datums)
			candidates.Remove(candidates)
			continue

	var/picked_antags = 0
	while(candidates.len || picked_antags < amount )
		var/mob/new_antag = pick_n_take(candidates)
		make_into_antag(new_antag)
		picked_antags++

	return picked_antags

/datum/oneclickantag/antagonist_spawner/on_station/make_into_antag(mob/target)
	if(!target.mind)
		return FALSE
	target.mind.add_antag_datum(antagonist_datum)

/datum/oneclickantag/antagonist_spawner/on_station/brother
	antagonist_name = ROLE_BROTHER
	antagonist_datum = /datum/antagonist/brother

/datum/oneclickantag/antagonist_spawner/on_station/brother/make_into_antag(mob/target)
	if(!target.mind)
		return FALSE

	var/datum/team/brother_team/team = new
	team.add_member(target)
	target.mind.add_antag_datum(/datum/antagonist/brother, team)
	return TRUE

/datum/oneclickantag/antagonist_spawner/on_station/changeling
	antagonist_name = ROLE_CHANGELING
	antagonist_datum = /datum/antagonist/changeling

/datum/oneclickantag/antagonist_spawner/on_station/cult
	antagonist_name = ROLE_CULTIST
	antagonist_datum = /datum/antagonist/cult

/datum/oneclickantag/antagonist_spawner/on_station/heretic
	antagonist_name = ROLE_HERETIC
	antagonist_datum = /datum/antagonist/heretic

/datum/oneclickantag/antagonist_spawner/on_station/malf_ai
	antagonist_name = ROLE_MALF
	antagonist_datum = /datum/antagonist/malf_ai

/datum/oneclickantag/antagonist_spawner/on_station/revolution
	antagonist_name = ROLE_REV_HEAD
	antagonist_datum = /datum/antagonist/rev/head

/datum/oneclickantag/antagonist_spawner/on_station/revolution/make_into_antag(mob/target)
	if(!target.mind)
		return FALSE

	target.mind.make_rev()

/datum/oneclickantag/antagonist_spawner/on_station/traitor
	antagonist_name = ROLE_TRAITOR
	antagonist_datum = /datum/antagonist/traitor

/datum/oneclickantag/antagonist_spawner/on_station/spy
	antagonist_name = ROLE_SPY
	antagonist_datum = /datum/antagonist/spy

/datum/oneclickantag/antagonist_spawner/on_station/midround
	category = CATEGORY_MIDROUND

/datum/oneclickantag/antagonist_spawner/on_station/midround/blob_infection
	antagonist_name = ROLE_BLOB_INFECTION
	antagonist_datum = /datum/antagonist/blob/infection

/datum/oneclickantag/antagonist_spawner/on_station/midround/malf_ai
	antagonist_name = ROLE_MALF_MIDROUND
	antagonist_datum = /datum/antagonist/malf_ai

/datum/oneclickantag/antagonist_spawner/on_station/midround/obsessed
	antagonist_name = ROLE_OBSESSED
	antagonist_datum = /datum/antagonist/obsessed

/datum/oneclickantag/antagonist_spawner/on_station/midround/obsessed/make_into_antag(mob/living/carbon/target)
	if(!target.mind)
		return FALSE
	if(!target.get_organ_slot(ORGAN_SLOT_BRAIN))
		return FALSE
	target.gain_trauma(/datum/brain_trauma/special/obsessed)

/datum/oneclickantag/antagonist_spawner/on_station/midround/sleeper_agent
	antagonist_name = ROLE_SLEEPER_AGENT
	antagonist_datum = /datum/antagonist/infiltrator/sleeper_agent

/datum/oneclickantag/antagonist_spawner/on_station/midround/mutant
	antagonist_name = ROLE_MUTANT
	antagonist_datum = /datum/antagonist/mutant

/datum/oneclickantag/antagonist_spawner/ghost_role
	category = CATEGORY_GHOTSROLE
	max_amount = 1
	var/tied_event

/datum/oneclickantag/antagonist_spawner/ghost_role/create_antags(amount)
	if(!tied_event)
		return 0
	var/datum/round_event/ghost_role/event = new tied_event()
	return amount

/datum/oneclickantag/antagonist_spawner/ghost_role/abductor
	antagonist_name = ROLE_ABDUCTOR
	tied_event = /datum/round_event/ghost_role/abductor

/datum/oneclickantag/antagonist_spawner/ghost_role/blob
	antagonist_name = ROLE_BLOB
	tied_event = /datum/round_event/ghost_role/blob

/datum/oneclickantag/antagonist_spawner/ghost_role/changeling
	antagonist_name = ROLE_CHANGELING_MIDROUND
	tied_event = /datum/round_event/ghost_role/changeling

/datum/oneclickantag/antagonist_spawner/ghost_role/lone_op
	antagonist_name = ROLE_LONE_OPERATIVE
	tied_event = /datum/round_event/ghost_role/operative

/datum/oneclickantag/antagonist_spawner/ghost_role/morph
	antagonist_name = ROLE_MORPH
	tied_event = /datum/round_event/ghost_role/morph

/datum/oneclickantag/antagonist_spawner/ghost_role/nightmare
	antagonist_name = ROLE_NIGHTMARE
	tied_event = /datum/round_event/ghost_role/nightmare

/datum/oneclickantag/antagonist_spawner/ghost_role/ninja
	antagonist_name = ROLE_NINJA
	tied_event = /datum/round_event/ghost_role/space_ninja

/datum/oneclickantag/antagonist_spawner/ghost_role/revenant
	antagonist_name = ROLE_REVENANT
	tied_event = /datum/round_event/ghost_role/revenant

/datum/oneclickantag/antagonist_spawner/ghost_role/space_dragon
	antagonist_name = ROLE_SPACE_DRAGON
	tied_event = /datum/round_event/ghost_role/space_dragon

/datum/oneclickantag/antagonist_spawner/ghost_role/borer
	antagonist_name = ROLE_BORER
	tied_event = /datum/round_event/ghost_role/cortical_borer

/datum/oneclickantag/antagonist_spawner/ghost_role/contractor
	antagonist_name = ROLE_DRIFTING_CONTRACTOR
	tied_event = /datum/round_event/ghost_role/contractor


/datum/oneclickantag/antagonist_spawner/ghost_role/alien
	max_amount = 10
	antagonist_name = ROLE_ALIEN
	tied_event = /datum/round_event/ghost_role/alien_infestation

/datum/oneclickantag/antagonist_spawner/ghost_role/alien/create_antags(amount)
	var/datum/round_event/ghost_role/alien_infestation/xenomorph_event = new(FALSE)
	xenomorph_event.spawncount = amount
	xenomorph_event.processing = TRUE

/datum/oneclickantag/antagonist_spawner/ghost_role/nuke
	max_amount = 10
	antagonist_name = ROLE_OPERATIVE_MIDROUND

/datum/oneclickantag/antagonist_spawner/ghost_role/nuke/create_antags(amount)
	var/list/mob/dead/observer/candidates = SSpolling.poll_ghost_candidates(
		question = "Looking for volunteers to become [span_notice(antagonist_name)]",
		check_jobban = antagonist_name,
		role = antagonist_name,
		poll_time = 30 SECONDS,
		alert_pic = /obj/structure/sign/poster/contraband/syndicate_recruitment,
		role_name_text = antagonist_name,
	)

	if (!candidates)
		return

	var/picked_antags = 0
	var/nukies = list()
	while (candidates.len || picked_antags < amount)
		nukies += pick_n_take(candidates)
		picked_antags++

	var/mob/leader = get_most_experienced(nukies, ROLE_NUCLEAR_OPERATIVE)
	candidates.Remove(leader)
	leader.mind.set_assigned_role(SSjob.GetJobType(/datum/job/nuclear_operative))
	leader.mind.special_role = ROLE_NUCLEAR_OPERATIVE
	var/datum/antagonist/nukeop/leader/leader_datum = new()
	leader.mind.add_antag_datum(leader_datum)

	var/datum/team/nuclear/nuke_team = leader_datum.nuke_team
	for(var/mob/nuker in nukies)
		nuker.mind.set_assigned_role(SSjob.GetJobType(/datum/job/nuclear_operative))
		nuker.mind.special_role = ROLE_NUCLEAR_OPERATIVE
		nuker.mind.add_antag_datum(/datum/antagonist/nukeop/leader, nuke_team)

/datum/oneclickantag/antagonist_spawner/ghost_role/paradox_clone
	antagonist_name = ROLE_PARADOX_CLONE

/datum/oneclickantag/antagonist_spawner/ghost_role/paradox_clone/create_antags(amount)
	var/list/mob/dead/observer/candidates = SSpolling.poll_ghost_candidates(
		question = "Looking for volunteers to become [span_notice(antagonist_name)]",
		check_jobban = antagonist_name,
		role = antagonist_name,
		poll_time = 30 SECONDS,
		alert_pic = /obj/effect/bluespace_stream,
		role_name_text = antagonist_name,
	)

	var/picked_antags = 0
	while (candidates.len || picked_antags < amount)
		var/mob/candidate = pick_n_take(candidates)
		spawn_clone(candidate)
		picked_antags++

/datum/oneclickantag/antagonist_spawner/ghost_role/paradox_clone/proc/spawn_clone(mob/dead/new_clone)
	var/list/spawn_location = find_maintenance_spawn(atmos_sensitive = TRUE)

	var/datum/mind/player_mind = new /datum/mind(new_clone.key)
	player_mind.active = TRUE

	var/mob/living/carbon/human/clone_victim = find_original()
	var/mob/living/carbon/human/clone = clone_victim.make_full_human_copy(spawn_location)
	player_mind.transfer_to(clone)

	var/datum/antagonist/paradox_clone/new_datum = player_mind.add_antag_datum(/datum/antagonist/paradox_clone)
	new_datum.original_ref = WEAKREF(clone_victim.mind)
	new_datum.setup_clone()

	playsound(clone, 'sound/weapons/zapbang.ogg', 30, TRUE)
	new /obj/item/storage/toolbox/mechanical(clone.loc)

/datum/oneclickantag/antagonist_spawner/ghost_role/paradox_clone/proc/find_original()
	var/list/possible_targets = list()

	var/opt_in_disabled = CONFIG_GET(flag/disable_antag_opt_in_preferences)
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(!player.client || !player.mind || player.stat)
			continue
		if(!(player.mind.assigned_role.job_flags & JOB_CREW_MEMBER))
			continue
		if (!opt_in_disabled && player.mind?.get_effective_opt_in_level() < OPT_IN_YES_ROUND_REMOVE)
			continue

	if(possible_targets.len)
		return pick(possible_targets)

/datum/oneclickantag/antagonist_spawner/ghost_role/spider
	max_amount = 10
	antagonist_name = ROLE_SPIDER

/datum/oneclickantag/antagonist_spawner/ghost_role/spider/create_antags(amount)
	create_midwife_eggs(amount)

/datum/oneclickantag/antagonist_spawner/ghost_role/wizard
	max_amount = 10
	antagonist_name = ROLE_WIZARD_MIDROUND

/datum/oneclickantag/antagonist_spawner/ghost_role/wizard/create_antags(amount)
	SSmapping.lazy_load_template(LAZY_TEMPLATE_KEY_WIZARDDEN)
	var/list/mob/dead/observer/candidates = SSpolling.poll_ghost_candidates(
		question = "Looking for volunteers to become [span_notice(antagonist_name)]",
		check_jobban = antagonist_name,
		role = antagonist_name,
		poll_time = 30 SECONDS,
		alert_pic = /obj/item/clothing/head/wizard,
		role_name_text = antagonist_name,
	)

	if(!candidates)
		return

	var/picked_antags = 0
	while(candidates.len || picked_antags < amount)
		var/mob/dead/observer/candidate = pick_n_take(candidates)
		var/mob/living/carbon/new_wiz
		new_wiz = make_body(candidate)
		new_wiz.mind.add_antag_datum(/datum/antagonist/wizard)
		picked_antags++

/datum/oneclickantag/antagonist_spawner/ghost_role/traitor
	max_amount = 10
	antagonist_name = ROLE_LONE_INFILTRATOR

/datum/oneclickantag/antagonist_spawner/ghost_role/traitor/create_antags(amount)
	var/list/mob/dead/observer/candidates = SSpolling.poll_ghost_candidates(
		question = "Looking for volunteers to become [span_notice(antagonist_name)]",
		check_jobban = antagonist_name,
		role = antagonist_name,
		poll_time = 30 SECONDS,
		alert_pic = /obj/structure/sign/poster/contraband/syndicate_recruitment,
		role_name_text = antagonist_name,
	)

	if(!candidates)
		return

	var/picked_antags = 0
	while(candidates.len || picked_antags < amount)
		var/mob/dead/observer/candidate = pick_n_take(candidates)
		var/datum/mind/player_mind = new /datum/mind(candidate.key)
		var/spawn_location = find_space_spawn()
		var/mob/living/carbon/human/operative = new(spawn_location)
		candidate.client.prefs.safe_transfer_prefs_to(operative)
		operative.dna.update_dna_identity()
		operative.dna.species.pre_equip_species_outfit(null, operative)
		operative.regenerate_icons()
		SSquirks.AssignQuirks(operative, candidate.client, TRUE, TRUE, null, FALSE, operative)
		player_mind.set_assigned_role(SSjob.GetJobType(/datum/job/lone_operative))
		player_mind.special_role = "Lone Infiltrator"
		player_mind.active = TRUE
		player_mind.transfer_to(operative)
		player_mind.add_antag_datum(/datum/antagonist/traitor/lone_infiltrator)

		picked_antags++
