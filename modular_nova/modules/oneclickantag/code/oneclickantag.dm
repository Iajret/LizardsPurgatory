GLOBAL_LIST_INIT(quick_antag_spawners, setup_antag_spawners())

/proc/setup_antag_spawners()
	. = list()
	for(var/spawner in typesof(/datum/oneclickantag/antagonist_spawner))
		var/datum/oneclickantag/antagonist_spawner/new_spawner = new spawner()
		if(new_spawner.antagonist_name)
			.[new_spawner.antagonist_name] = new_spawner

ADMIN_VERB(one_click_antag, R_ADMIN, "Create Antagonist", "Auto-create an antagonist of your choice", ADMIN_CATEGORY_EVENTS)
	var/datum/oneclickantag/tgui = new(usr)
	tgui.ui_interact(usr)

/datum/oneclickantag

/datum/oneclickantag/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OneClickAntag")
		ui.open()

/datum/oneclickantag/ui_state(mob/user)
	return GLOB.admin_state

/datum/oneclickantag/ui_data(mob/user)
	var/list/data = list()
	for (var/antag_name in GLOB.quick_antag_spawners)
		var/datum/oneclickantag/antagonist_spawner/spawner = GLOB.quick_antag_spawners[antag_name]
		data[spawner.category] += list(antag_name)
	return data

/datum/oneclickantag/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/antag = params["name"]

	var/datum/oneclickantag/antagonist_spawner/spawner = GLOB.quick_antag_spawners[antag]
	var/max_amount = spawner.max_amount
	var/amount = tgui_input_number(usr, "How much?", antag, max_amount)
	if(!amount)
		return

	message_admins("[key_name(usr)] has attempted to create [amount] of [antag]")
	if(spawner.create_antags(amount))
		log_admin("[key_name(usr)] created [amount] of [antag]")
		message_admins("[key_name(usr)] created [amount] of [antag]")
