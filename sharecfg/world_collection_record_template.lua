pg = pg or {}
pg.world_collection_record_template = rawget(pg, "world_collection_record_template") or setmetatable({
	__name = "world_collection_record_template"
}, confNEO)
pg.world_collection_record_template.all = {
	100001,
	100002,
	100003,
	100004,
	100005,
	100006,
	100007,
	100008,
	100009,
	100010,
	100011,
	100012,
	100013,
	100014,
	100015,
	100016,
	100017,
	100018,
	100019,
	100020,
	100021,
	100022,
	100023,
	100024,
	100025,
	100026,
	100027,
	100028,
	100029,
	100030,
	100031,
	100032,
	100033,
	100034,
	100035,
	100036,
	100037,
	100038,
	100039,
	100040,
	100041,
	100042,
	100043,
	100044,
	100045,
	100046,
	100047,
	100048,
	100049,
	100050,
	100051,
	100052,
	100053,
	100054,
	100055,
	100056,
	100057,
	100058,
	100059,
	100060,
	100061,
	100062,
	100063,
	100064,
	100065,
	100066,
	100071,
	100076,
	100077,
	100078,
	100079,
	100080,
	100081,
	100082,
	100083,
	100084,
	100085,
	100086,
	100087,
	100088,
	100089,
	100090,
	100091,
	100092,
	100093,
	100094,
	100095,
	100096,
	100097
}
pg.base = pg.base or {}
pg.base.world_collection_record_template = {}

;(function()
	pg.base.world_collection_record_template[100001] = {
		type = 1,
		name = "Operation Briefing",
		id = 100001,
		mask = "bg/bg_memory",
		group_ID = 1,
		icon = "memory_dashijie",
		condition = "Begin Operation Siren.",
		story = "WORLD100A"
	}
	pg.base.world_collection_record_template[100002] = {
		type = 1,
		name = "Prologue - Part I",
		id = 100002,
		mask = "bg/bg_memory",
		group_ID = 2,
		icon = "memory_dashijie",
		condition = "Complete Chapter 1-1.",
		story = "GWORLD101A"
	}
	pg.base.world_collection_record_template[100003] = {
		type = 1,
		name = "Prologue - Part II",
		id = 100003,
		mask = "bg/bg_memory",
		group_ID = 3,
		icon = "memory_dashijie",
		condition = "Talk to Hornet.",
		story = "GWORLD101B"
	}
	pg.base.world_collection_record_template[100004] = {
		type = 1,
		name = "Prologue - Part III",
		id = 100004,
		mask = "bg/bg_memory",
		group_ID = 4,
		icon = "memory_dashijie",
		condition = "Train with Hornet.",
		story = "GWORLD101C"
	}
	pg.base.world_collection_record_template[100005] = {
		type = 1,
		name = "Prologue - Part IV",
		id = 100005,
		mask = "bg/bg_memory",
		group_ID = 5,
		icon = "memory_dashijie",
		condition = "After retreating from battle.",
		story = "GWORLD101D"
	}
	pg.base.world_collection_record_template[100006] = {
		type = 1,
		name = "The Bugle Sounds",
		id = 100006,
		mask = "bg/bg_memory",
		group_ID = 6,
		icon = "memory_dashijie",
		condition = "Visit the NY City harbor.",
		story = "WORLD102A"
	}
	pg.base.world_collection_record_template[100007] = {
		type = 1,
		name = "Once More, Into battle",
		id = 100007,
		mask = "bg/bg_memory",
		group_ID = 7,
		icon = "memory_dashijie",
		condition = "Begin 1-2.",
		story = "WORLD105A"
	}
	pg.base.world_collection_record_template[100008] = {
		type = 1,
		name = "Radar Module",
		id = 100008,
		mask = "bg/bg_memory",
		group_ID = 8,
		icon = "memory_dashijie",
		condition = "Visit the 1-2 rally point.",
		story = "WORLD105B"
	}
	pg.base.world_collection_record_template[100009] = {
		type = 1,
		name = "Recollection",
		id = 100009,
		mask = "bg/bg_memory",
		group_ID = 9,
		icon = "memory_dashijie",
		condition = "Defeat all enemies in zone 1.",
		story = "WORLD105C"
	}
	pg.base.world_collection_record_template[100010] = {
		type = 1,
		name = "Traces",
		id = 100010,
		mask = "bg/bg_memory",
		group_ID = 10,
		icon = "memory_dashijie",
		condition = "Defeat all enemies in zone 2.",
		story = "WORLD105D"
	}
	pg.base.world_collection_record_template[100011] = {
		type = 1,
		name = "The Mysterious Ship",
		id = 100011,
		mask = "bg/bg_memory",
		group_ID = 11,
		icon = "memory_dashijie",
		condition = "Visit the 1-3 rally point.",
		story = "WORLD105E"
	}
	pg.base.world_collection_record_template[100012] = {
		type = 1,
		name = "The Enemy of My Enemy",
		id = 100012,
		mask = "bg/bg_memory",
		group_ID = 12,
		icon = "memory_dashijie",
		condition = "Begin 1-3.",
		story = "WORLD106A"
	}
	pg.base.world_collection_record_template[100013] = {
		type = 1,
		name = "The Search - Part I",
		id = 100013,
		mask = "bg/bg_memory",
		group_ID = 13,
		icon = "memory_dashijie",
		condition = "Visit the 1-3 rally point.",
		story = "WORLD106B"
	}
	pg.base.world_collection_record_template[100014] = {
		type = 1,
		name = "The Search - Part II",
		id = 100014,
		mask = "bg/bg_memory",
		group_ID = 14,
		icon = "memory_dashijie",
		condition = "Visit the 1-3 rally point.",
		story = "WORLD106C"
	}
	pg.base.world_collection_record_template[100015] = {
		type = 1,
		name = "The Search - Part III",
		id = 100015,
		mask = "bg/bg_memory",
		group_ID = 15,
		icon = "memory_dashijie",
		condition = "Visit the 1-3 rally point.",
		story = "WORLD106D"
	}
	pg.base.world_collection_record_template[100016] = {
		type = 1,
		name = "Securing the Zone",
		id = 100016,
		mask = "bg/bg_memory",
		group_ID = 16,
		icon = "memory_dashijie",
		condition = "Defeat all enemies.",
		story = "WORLD106E"
	}
	pg.base.world_collection_record_template[100017] = {
		type = 1,
		name = "Securing the Zone",
		id = 100017,
		mask = "bg/bg_memory",
		group_ID = 17,
		icon = "memory_dashijie",
		condition = "Begin 1-4.",
		story = "WORLD107A"
	}
	pg.base.world_collection_record_template[100018] = {
		type = 1,
		name = "The Crimson Axis",
		id = 100018,
		mask = "bg/bg_memory",
		group_ID = 18,
		icon = "memory_dashijie",
		condition = "Defeat 5 enemy fleets.",
		story = "WORLD107B"
	}
	pg.base.world_collection_record_template[100019] = {
		type = 1,
		name = "Communications",
		id = 100019,
		mask = "bg/bg_memory",
		group_ID = 19,
		icon = "memory_dashijie",
		condition = "Visit the 1-5 rally point.",
		story = "WORLD108A"
	}
	pg.base.world_collection_record_template[100020] = {
		type = 1,
		name = "Aviation Battle",
		id = 100020,
		mask = "bg/bg_memory",
		group_ID = 20,
		icon = "memory_dashijie",
		condition = "Visit the 1-5 rally point.",
		story = "WORLD108B"
	}
	pg.base.world_collection_record_template[100021] = {
		type = 1,
		name = "Ceasefire...?",
		id = 100021,
		mask = "bg/bg_memory",
		group_ID = 21,
		icon = "memory_dashijie",
		condition = "Repel the Iron Blood forces.",
		story = "WORLD108C"
	}
	pg.base.world_collection_record_template[100022] = {
		type = 1,
		name = "Necessary Preparations",
		id = 100022,
		mask = "bg/bg_memory",
		group_ID = 22,
		icon = "memory_dashijie",
		condition = "Visit the 1-6 rally point.",
		story = "WORLD109A"
	}
	pg.base.world_collection_record_template[100023] = {
		type = 1,
		name = "Preparations Complete",
		id = 100023,
		mask = "bg/bg_memory",
		group_ID = 23,
		icon = "memory_dashijie",
		condition = "Visit the 1-6 rally point.",
		story = "WORLD109B"
	}
	pg.base.world_collection_record_template[100024] = {
		type = 1,
		name = "META Beacon",
		id = 100024,
		mask = "bg/bg_memory",
		group_ID = 24,
		icon = "memory_dashijie",
		condition = "Unlock META Showdown.",
		story = "GWORLD109A"
	}
	pg.base.world_collection_record_template[100025] = {
		type = 1,
		name = "The Queen's Duty",
		id = 100025,
		mask = "bg/bg_memory",
		group_ID = 1,
		icon = "memory_dashijie",
		condition = "Dock in the port at 2-1.",
		story = "WORLD200A"
	}
	pg.base.world_collection_record_template[100026] = {
		type = 1,
		name = "Setting Sail",
		id = 100026,
		mask = "bg/bg_memory",
		group_ID = 2,
		icon = "memory_dashijie",
		condition = "Visit the 2-1 rally point.",
		story = "WORLD200B"
	}
	pg.base.world_collection_record_template[100027] = {
		type = 1,
		name = "Side by Side",
		id = 100027,
		mask = "bg/bg_memory",
		group_ID = 3,
		icon = "memory_dashijie",
		condition = "Visit the 2-2 rally point.",
		story = "WORLD201A"
	}
	pg.base.world_collection_record_template[100028] = {
		type = 1,
		name = "Sector Sweep",
		id = 100028,
		mask = "bg/bg_memory",
		group_ID = 4,
		icon = "memory_dashijie",
		condition = "Begin 2-3.",
		story = "WORLD202A"
	}
	pg.base.world_collection_record_template[100029] = {
		type = 1,
		name = "Distress Signal",
		id = 100029,
		mask = "bg/bg_memory",
		group_ID = 5,
		icon = "memory_dashijie",
		condition = "Defeat all enemies.",
		story = "WORLD202B"
	}
	pg.base.world_collection_record_template[100030] = {
		type = 1,
		name = "Disaster Site",
		id = 100030,
		mask = "bg/bg_memory",
		group_ID = 6,
		icon = "memory_dashijie",
		condition = "Begin 2-4.",
		story = "WORLD203A"
	}
	pg.base.world_collection_record_template[100031] = {
		type = 1,
		name = "Desolation",
		id = 100031,
		mask = "bg/bg_memory",
		group_ID = 7,
		icon = "memory_dashijie",
		condition = "Visit the 2-4 rally point.",
		story = "WORLD203B"
	}
	pg.base.world_collection_record_template[100032] = {
		type = 1,
		name = "Devestation",
		id = 100032,
		mask = "bg/bg_memory",
		group_ID = 8,
		icon = "memory_dashijie",
		condition = "Visit the 2-4 rally point.",
		story = "WORLD203C"
	}
	pg.base.world_collection_record_template[100033] = {
		type = 1,
		name = "Special Mission",
		id = 100033,
		mask = "bg/bg_memory",
		group_ID = 9,
		icon = "memory_dashijie",
		condition = "Visit the 2-4 rally point.",
		story = "WORLD203D"
	}
	pg.base.world_collection_record_template[100034] = {
		type = 1,
		name = "Message from Her Majesty",
		id = 100034,
		mask = "bg/bg_memory",
		group_ID = 10,
		icon = "memory_dashijie",
		condition = "Visit the 2-5 rally point.",
		story = "WORLD204A"
	}
	pg.base.world_collection_record_template[100035] = {
		type = 1,
		name = "Gravitational Anomaly",
		id = 100035,
		mask = "bg/bg_memory",
		group_ID = 11,
		icon = "memory_dashijie",
		condition = "Begin 2-6.",
		story = "WORLD205A"
	}
	pg.base.world_collection_record_template[100036] = {
		type = 1,
		name = "A Matter of Acclimation",
		id = 100036,
		mask = "bg/bg_memory",
		group_ID = 12,
		icon = "memory_dashijie",
		condition = "Defeat all enemies.",
		story = "WORLD205B"
	}
	pg.base.world_collection_record_template[100037] = {
		type = 1,
		name = "Impenetrable",
		id = 100037,
		mask = "bg/bg_memory",
		group_ID = 13,
		icon = "memory_dashijie",
		condition = "Defeat the special unit on 2-6.",
		story = "WORLD205C"
	}
	pg.base.world_collection_record_template[100038] = {
		type = 1,
		name = "Conclusion",
		id = 100038,
		mask = "bg/bg_memory",
		group_ID = 14,
		icon = "memory_dashijie",
		condition = "Defeat the special unit.",
		story = "WORLD205D"
	}
	pg.base.world_collection_record_template[100039] = {
		type = 1,
		name = "Detached Force",
		id = 100039,
		mask = "bg/bg_memory",
		group_ID = 1,
		icon = "memory_dashijie",
		condition = "Dock in the port at 3-1.",
		story = "WORLD300A"
	}
	pg.base.world_collection_record_template[100040] = {
		type = 1,
		name = "TB Systems Test",
		id = 100040,
		mask = "bg/bg_memory",
		group_ID = 2,
		icon = "memory_dashijie",
		condition = "Visit the 3-1 rally point.",
		story = "WORLD300B"
	}
	pg.base.world_collection_record_template[100041] = {
		type = 1,
		name = "Iron Blood's Movements",
		id = 100041,
		mask = "bg/bg_memory",
		group_ID = 3,
		icon = "memory_dashijie",
		condition = "Visit the 3-2 rally point.",
		story = "WORLD301A"
	}
	pg.base.world_collection_record_template[100042] = {
		type = 1,
		name = "Allied Activity?",
		id = 100042,
		mask = "bg/bg_memory",
		group_ID = 4,
		icon = "memory_dashijie",
		condition = "Visit the 3-3 rally point.",
		story = "WORLD302A"
	}
	pg.base.world_collection_record_template[100043] = {
		type = 1,
		name = "Jamming",
		id = 100043,
		mask = "bg/bg_memory",
		group_ID = 5,
		icon = "memory_dashijie",
		condition = "Visit the 3-3 rally point.",
		story = "WORLD302B"
	}
	pg.base.world_collection_record_template[100044] = {
		type = 1,
		name = "Relief",
		id = 100044,
		mask = "bg/bg_memory",
		group_ID = 6,
		icon = "memory_dashijie",
		condition = "Visit the 3-4 rally point.",
		story = "WORLD303A"
	}
	pg.base.world_collection_record_template[100045] = {
		type = 1,
		name = "Suspicions",
		id = 100045,
		mask = "bg/bg_memory",
		group_ID = 7,
		icon = "memory_dashijie",
		condition = "Visit the 3-4 rally point.",
		story = "WORLD303B"
	}
	pg.base.world_collection_record_template[100046] = {
		type = 1,
		name = "Weather Task Force",
		id = 100046,
		mask = "bg/bg_memory",
		group_ID = 8,
		icon = "memory_dashijie",
		condition = "Visit the 3-5 rally point.",
		story = "WORLD304A"
	}
	pg.base.world_collection_record_template[100047] = {
		type = 1,
		name = "Phantoms",
		id = 100047,
		mask = "bg/bg_memory",
		group_ID = 9,
		icon = "memory_dashijie",
		condition = "Visit the 3-5 rally point.",
		story = "WORLD304B"
	}
	pg.base.world_collection_record_template[100048] = {
		type = 1,
		name = "Arbiter",
		id = 100048,
		mask = "bg/bg_memory",
		group_ID = 10,
		icon = "memory_dashijie",
		condition = "Visit the 3-5 rally point.",
		story = "WORLD304C"
	}
	pg.base.world_collection_record_template[100049] = {
		type = 1,
		name = "Backup",
		id = 100049,
		mask = "bg/bg_memory",
		group_ID = 11,
		icon = "memory_dashijie",
		condition = "Defeat all enemies.",
		story = "WORLD304D"
	}
	pg.base.world_collection_record_template[100050] = {
		type = 1,
		name = "Precise Measurements",
		id = 100050,
		mask = "bg/bg_memory",
		group_ID = 12,
		icon = "memory_dashijie",
		condition = "Defeat the special unit.",
		story = "WORLD304E"
	}
	pg.base.world_collection_record_template[100051] = {
		type = 1,
		name = "Focused Offensive",
		id = 100051,
		mask = "bg/bg_memory",
		group_ID = 13,
		icon = "memory_dashijie",
		condition = "Begin 3-3.",
		story = "WORLD305A"
	}
	pg.base.world_collection_record_template[100052] = {
		type = 1,
		name = "Rest",
		id = 100052,
		mask = "bg/bg_memory",
		group_ID = 14,
		icon = "memory_dashijie",
		condition = "Visit the 3-6 rally point.",
		story = "WORLD305B"
	}
	pg.base.world_collection_record_template[100053] = {
		type = 1,
		name = "Ocean Voyage",
		id = 100053,
		mask = "bg/bg_memory",
		group_ID = 1,
		icon = "memory_dashijie",
		condition = "Visit the 4-1 rally point.",
		story = "WORLD400A"
	}
	pg.base.world_collection_record_template[100054] = {
		type = 1,
		name = "Sardegna",
		id = 100054,
		mask = "bg/bg_memory",
		group_ID = 2,
		icon = "memory_dashijie",
		condition = "Visit the 4-1 rally point.",
		story = "WORLD400B"
	}
	pg.base.world_collection_record_template[100055] = {
		type = 1,
		name = "Taranto",
		id = 100055,
		mask = "bg/bg_memory",
		group_ID = 3,
		icon = "memory_dashijie",
		condition = "Begin 4-2.",
		story = "WORLD401A"
	}
	pg.base.world_collection_record_template[100056] = {
		type = 1,
		name = "Leaving Midway",
		id = 100056,
		mask = "bg/bg_memory",
		group_ID = 4,
		icon = "memory_dashijie",
		condition = "Visit the 4-2 rally point.",
		story = "WORLD401B"
	}
	pg.base.world_collection_record_template[100057] = {
		type = 1,
		name = "Dakar",
		id = 100057,
		mask = "bg/bg_memory",
		group_ID = 5,
		icon = "memory_dashijie",
		condition = "Begin 4-3.",
		story = "WORLD402A"
	}
	pg.base.world_collection_record_template[100058] = {
		type = 1,
		name = "Solo Operation",
		id = 100058,
		mask = "bg/bg_memory",
		group_ID = 6,
		icon = "memory_dashijie",
		condition = "Visit the 4-3 rally point.",
		story = "WORLD402B"
	}
	pg.base.world_collection_record_template[100059] = {
		type = 1,
		name = "Uncertainty",
		id = 100059,
		mask = "bg/bg_memory",
		group_ID = 7,
		icon = "memory_dashijie",
		condition = "Defeat all enemies.",
		story = "WORLD403A"
	}
	pg.base.world_collection_record_template[100060] = {
		type = 1,
		name = "Incursion",
		id = 100060,
		mask = "bg/bg_memory",
		group_ID = 8,
		icon = "memory_dashijie",
		condition = "Begin 4-5.",
		story = "WORLD404A"
	}
	pg.base.world_collection_record_template[100061] = {
		type = 1,
		name = "Anomaly",
		id = 100061,
		mask = "bg/bg_memory",
		group_ID = 9,
		icon = "memory_dashijie",
		condition = "Visit the 4-5 rally point.",
		story = "WORLD404B"
	}
	pg.base.world_collection_record_template[100062] = {
		type = 1,
		name = "Illusion",
		id = 100062,
		mask = "bg/bg_memory",
		group_ID = 10,
		icon = "memory_dashijie",
		condition = "Visit the 4-5 rally point.",
		story = "WORLD404C"
	}
	pg.base.world_collection_record_template[100063] = {
		type = 1,
		name = "Substitute",
		id = 100063,
		mask = "bg/bg_memory",
		group_ID = 11,
		icon = "memory_dashijie",
		condition = "Visit the 4-5 rally point.",
		story = "WORLD404D"
	}
	pg.base.world_collection_record_template[100064] = {
		type = 1,
		name = "Warrior’s Awakening",
		id = 100064,
		mask = "bg/bg_memory",
		group_ID = 12,
		icon = "memory_dashijie",
		condition = "Begin 4-6.",
		story = "WORLD405A"
	}
	pg.base.world_collection_record_template[100065] = {
		type = 1,
		name = "The Arbitrating Sage",
		id = 100065,
		mask = "bg/bg_memory",
		group_ID = 13,
		icon = "memory_dashijie",
		condition = "Defeat all enemies.",
		story = "WORLD405B"
	}
	pg.base.world_collection_record_template[100066] = {
		type = 1,
		name = "Escape",
		id = 100066,
		mask = "bg/bg_memory",
		group_ID = 14,
		icon = "memory_dashijie",
		condition = "Defeat the special unit.",
		story = "WORLD405C"
	}
	pg.base.world_collection_record_template[100071] = {
		type = 1,
		name = "Classified Intel",
		id = 100071,
		mask = "bg/bg_memory",
		group_ID = 1,
		icon = "memory_dashijie",
		condition = "???",
		story = "WORLD9901A"
	}
	pg.base.world_collection_record_template[100076] = {
		type = 1,
		name = "Bogged Down",
		id = 100076,
		mask = "bg/bg_memory",
		group_ID = 1,
		icon = "memory_dashijie",
		condition = "Arrive at the 5-1 forward base.",
		story = "WORLD500A"
	}
	pg.base.world_collection_record_template[100077] = {
		type = 1,
		name = "Division",
		id = 100077,
		mask = "bg/bg_memory",
		group_ID = 2,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "WORLD500B"
	}
	pg.base.world_collection_record_template[100078] = {
		type = 1,
		name = "Thunder",
		id = 100078,
		mask = "bg/bg_memory",
		group_ID = 3,
		icon = "memory_dashijie",
		condition = "Arrive at the 5-1 forward base.",
		story = "WORLD500C"
	}
	pg.base.world_collection_record_template[100079] = {
		type = 1,
		name = "My Hero",
		id = 100079,
		mask = "bg/bg_memory",
		group_ID = 4,
		icon = "memory_dashijie",
		condition = "Begin Chapter 5-2.",
		story = "WORLD501A"
	}
	pg.base.world_collection_record_template[100080] = {
		type = 1,
		name = "Coordinates",
		id = 100080,
		mask = "bg/bg_memory",
		group_ID = 5,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "WORLD501B"
	}
	pg.base.world_collection_record_template[100081] = {
		type = 1,
		name = "A Deep Longing",
		id = 100081,
		mask = "bg/bg_memory",
		group_ID = 6,
		icon = "memory_dashijie",
		condition = "Encounter Hiryuu META.",
		story = "WORLD501C"
	}
	pg.base.world_collection_record_template[100082] = {
		type = 1,
		name = "The Phantom",
		id = 100082,
		mask = "bg/bg_memory",
		group_ID = 7,
		icon = "memory_dashijie",
		condition = "Begin Chapter 5-3.",
		story = "WORLD502A"
	}
	pg.base.world_collection_record_template[100083] = {
		type = 1,
		name = "One's Resolution",
		id = 100083,
		mask = "bg/bg_memory",
		group_ID = 8,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "WORLD503A"
	}
	pg.base.world_collection_record_template[100084] = {
		type = 1,
		name = "Teatime",
		id = 100084,
		mask = "bg/bg_memory",
		group_ID = 9,
		icon = "memory_dashijie",
		condition = "Arrive at the 5-4 forward base.",
		story = "WORLD503B"
	}
	pg.base.world_collection_record_template[100085] = {
		type = 1,
		name = "All-Out Offensive",
		id = 100085,
		mask = "bg/bg_memory",
		group_ID = 10,
		icon = "memory_dashijie",
		condition = "Begin Chapter 5-5.",
		story = "WORLD504A"
	}
	pg.base.world_collection_record_template[100086] = {
		type = 1,
		name = "The Mighty KGV's",
		id = 100086,
		mask = "bg/bg_memory",
		group_ID = 11,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "WORLD504B"
	}
	pg.base.world_collection_record_template[100087] = {
		type = 1,
		name = "Guerrilla Tactics",
		id = 100087,
		mask = "bg/bg_memory",
		group_ID = 12,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "WORLD504C"
	}
	pg.base.world_collection_record_template[100088] = {
		type = 1,
		name = "Wings in the Sky",
		id = 100088,
		mask = "bg/bg_memory",
		group_ID = 13,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "WORLD504D"
	}
	pg.base.world_collection_record_template[100089] = {
		type = 1,
		name = "Vessels",
		id = 100089,
		mask = "bg/bg_memory",
		group_ID = 14,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "WORLD504E"
	}
	pg.base.world_collection_record_template[100090] = {
		type = 1,
		name = "Torus",
		id = 100090,
		mask = "bg/bg_memory",
		group_ID = 15,
		icon = "memory_dashijie",
		condition = "Begin Chapter 5-6.",
		story = "WORLD505A"
	}
	pg.base.world_collection_record_template[100091] = {
		type = 1,
		name = "Another Singularity",
		id = 100091,
		mask = "bg/bg_memory",
		group_ID = 16,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "WORLD505B"
	}
	pg.base.world_collection_record_template[100092] = {
		type = 1,
		name = "An Invitation",
		id = 100092,
		mask = "bg/bg_memory",
		group_ID = 17,
		icon = "memory_dashijie",
		condition = "Begin Chapter 5-7.",
		story = "WORLD506A"
	}
	pg.base.world_collection_record_template[100093] = {
		type = 1,
		name = "Respite and Repairs",
		id = 100093,
		mask = "bg/bg_memory",
		group_ID = 18,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "WORLD506B"
	}
	pg.base.world_collection_record_template[100094] = {
		type = 1,
		name = "Rejection",
		id = 100094,
		mask = "bg/bg_memory",
		group_ID = 19,
		icon = "memory_dashijie",
		condition = "Begin Chapter 5-8.",
		story = "WORLD507A"
	}
	pg.base.world_collection_record_template[100095] = {
		type = 1,
		name = "Point of Convergence",
		id = 100095,
		mask = "bg/bg_memory",
		group_ID = 20,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "WORLD507E"
	}
	pg.base.world_collection_record_template[100096] = {
		type = 2,
		name = "Last Light ",
		id = 100096,
		mask = "bg/bg_memory",
		group_ID = 21,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "312671"
	}
	pg.base.world_collection_record_template[100097] = {
		type = 2,
		name = "A New Chapter ",
		id = 100097,
		mask = "bg/bg_memory",
		group_ID = 22,
		icon = "memory_dashijie",
		condition = "Investigate the next point of interest.",
		story = "312672"
	}
end)()
