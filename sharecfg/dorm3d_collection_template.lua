pg = pg or {}
pg.dorm3d_collection_template = setmetatable({
	__name = "dorm3d_collection_template",
	get_id_list_by_room_id = {
		{
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10,
			11,
			12,
			13,
			14,
			15,
			16,
			17,
			18,
			19,
			20,
			21,
			22,
			23,
			24,
			25,
			26,
			27,
			28,
			29,
			30
		},
		[4] = {
			31,
			32,
			33,
			34,
			35,
			36,
			37,
			38,
			39
		},
		{
			51,
			52,
			53,
			54,
			55,
			56,
			57,
			58,
			59,
			60,
			61,
			62,
			63,
			64,
			65,
			66,
			67,
			68,
			70,
			72,
			71,
			76,
			77,
			78,
			79,
			74,
			75
		}
	},
	all = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
		17,
		18,
		19,
		20,
		21,
		22,
		23,
		24,
		25,
		26,
		27,
		28,
		29,
		30,
		31,
		32,
		33,
		34,
		35,
		36,
		37,
		38,
		39,
		51,
		52,
		53,
		54,
		55,
		56,
		57,
		58,
		59,
		60,
		61,
		62,
		63,
		64,
		65,
		66,
		67,
		68,
		70,
		72,
		71,
		76,
		77,
		78,
		79,
		74,
		75
	}
}, confHX)
pg.base = pg.base or {}
pg.base.dorm3d_collection_template = {
	{
		text = "dorm3d_sirius_table",
		name = "Microwave Oven",
		award = 0,
		time = 0,
		id = 1,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item5",
		desc = "A microwave oven Sirius bought herself. Despite seeing heavy use, it somehow looks as pristine as the day it was purchased.",
		model = {
			"fbx/litmap_04/pre_db_electrical01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_04/pre_db_electrical01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_table",
		name = "Coffee Machine",
		award = 0,
		time = 0,
		id = 2,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item6",
		desc = "Sirius uses this to make coffee every morning.The machine still has traces of her fingerprints on it.",
		model = {
			"fbx/litmap_04/pre_db_electrical07"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_04/pre_db_electrical07/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_table",
		name = "Mary Janes",
		award = 0,
		time = 1,
		id = 3,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item2",
		desc = "The pair of shoes that Sirius wears all the time. They are loved and cared for, and thus the leather retains its soft luster.",
		model = {
			"fbx/litmap_01/pre_db_shoe01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_01/pre_db_shoe01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_table",
		name = "Wall-Mounted Photograph",
		award = 0,
		time = 0,
		id = 4,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item8",
		desc = "The subject is an orange tabby wearing a blue necktie. Behind the apparent sophistication lies a silly but cute appeal. It's safe to say the tenant likes this particular kind of cuteness.",
		model = {
			"fbx/litmap_03/pre_db_billboard06d"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_billboard06d/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_chair",
		name = "Toaster",
		award = 0,
		time = 1,
		id = 5,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item9",
		desc = "A very practical machine for the novice at-home cook. Drop in some bread slices, push down, and soon you'll have hot, crispy toast. You can of course adjust how toasty you want it.",
		model = {
			"no_bake_prop/pre_db_electrical02"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_electrical02/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_chair",
		name = "Trash Can",
		award = 0,
		time = 1,
		id = 6,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item10",
		desc = "Also known as a \"rubbish bin\" in some parts of the world. You look and you look, but you can't find anything unusual about this wholly unremarkable waste receptacle.",
		model = {
			"no_bake_prop/pre_db_pail01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_pail01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_chair",
		name = "Blue Sky Picture Frame",
		award = 0,
		time = 0,
		id = 7,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item17",
		desc = "This frame doesn't have a proper photo in it yet. The placeholder image is just there to look more appealing than a plain beige background.",
		model = {
			"fbx/litmap_03/pre_db_billboard02"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_billboard02/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_chair",
		name = "Preserved Butterfly",
		award = 0,
		time = 0,
		id = 8,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item12",
		desc = "The pattern on its wings reminds you of a wave washing up on a shore, and of Sirius sprinting across the sea, her hair fluttering in the wind. You should invite Sirius to go on a walk on the beach the next time you're free.",
		model = {
			"fbx/litmap_03/pre_db_billboard03 (1)"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_billboard03 (1)/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_chair",
		name = "Floor Lamp",
		award = 0,
		time = 0,
		id = 9,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item15",
		desc = "A floor lamp standing just by the couch. Sirius graciously thought ahead and picked a bulb that wouldn't strain your eyes. You could see yourself working from here every now and then.",
		model = {
			"fbx/litmap_03/pre_db_chandelier06"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_chandelier06/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Bread Plate",
		award = 0,
		time = 1,
		id = 10,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item16",
		desc = "Two sandwiches and a croissant. Baked by Sirius, from the looks of it. Although they look and smell perfectly fine, you probably shouldn't taste them until Sirius urges you to.",
		model = {
			"fbx/litmap_04/pre_db_food01b"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_04/pre_db_food01b/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Recreational Reading",
		award = 0,
		time = 1,
		id = 11,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item25",
		desc = "A book lying on the table by the bed. Sirius has been reading this one quite a lot lately. After flipping through a few pages, you figure out that it's a story about a forbidden love between a maid and her master.",
		model = {
			"no_bake_prop/pre_db_book01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_book01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bath",
		name = "Wine Glasses",
		award = 0,
		time = 1,
		id = 12,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item14",
		desc = "They're filled not with wine, but water. A perfect illustration of the kind of service Sirius provides. Although, drinking water from a wine glass with your pinky extended is a chore. You should tell her to get some regular glasses someday.",
		model = {
			"no_bake_prop/pre_db_tableware07"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_tableware07/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bath",
		name = "Legendary Sword Replica",
		award = 0,
		time = 0,
		id = 13,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item11",
		desc = "A replica of the hero's sword from the smash hit port virtual reality RPG. The stand says, \"For Kitchen Adventures.\" It's no wonder why the one in Sirius' room feels so much heavier.",
		model = {
			"no_bake_prop/pre_db_decoration02"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_decoration02/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bath",
		name = "Flower Arrangement 1",
		award = 0,
		time = 0,
		id = 14,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item19",
		desc = "One of the fruits of Sirius' practicing of flower arrangement. While it isn't very varied in color, the flowers are distributed well. These would look better in a more open place.",
		model = {
			"fbx/litmap_04/pre_db_ceram05 (1)"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_04/pre_db_ceram05 (1)/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Bedside Books",
		award = 0,
		time = 1,
		id = 15,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item20",
		desc = "A pile of books lying by the bedside. Surprisingly, they're not all about cooking – they cover subjects like military tactics and how to provide optimal service. Sirius' personal notes are layered between the books. Judging by their contents, she's diligently studying to become an even better maid.",
		model = {
			"fbx/litmap_01/pre_db_book08"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_01/pre_db_book08/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Dresser",
		award = 0,
		time = 0,
		id = 16,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item22",
		desc = "Sirius must have been in a rush to see you, because she forgot to put the cap back on her lipstick. Be kind and do it for her!",
		model = {
			"no_bake_prop/pre_db_dressingtablecomponents01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_dressingtablecomponents01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Jewelry Case",
		award = 0,
		time = 0,
		id = 17,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item18",
		desc = "An expensive piece of jewelry. Sirius hasn't worn it even once, preferring to keep it nice and safe behind the glass.",
		model = {
			"no_bake_prop/pre_db_jewelrybox01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_jewelrybox01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Flower Arrangement 2",
		award = 0,
		time = 0,
		id = 18,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item26",
		desc = "A pair of pretty yellow roses. They bring a sunny mood to whatever table they find themselves atop. You start to wonder what flower is Sirius' favorite.",
		model = {
			"fbx/litmap_02/pre_db_ceram10_01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_02/pre_db_ceram10_01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Mystery Novel",
		award = 0,
		time = 1,
		id = 19,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item28",
		desc = "A mystery book yet to be even opened. One can assume this genre isn't Sirius' cup of tea for the time being.",
		model = {
			"fbx/litmap_02/pre_db_book02"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_02/pre_db_book02/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Stuffed Shiba Inu",
		award = 0,
		time = 1,
		id = 20,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item29",
		desc = "It has writing on its stomach that reads, \"EXPERTLY CRAFTED BY AKASHI.\" Sirius is a regular patron of hers.",
		model = {
			"fbx/litmap_03/pre_db_toy03"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_toy03/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bath",
		name = "A Summer Memory",
		award = 0,
		time = 0,
		id = 21,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item30",
		desc = "The float ring Sirius used when you went to the beach with her. It's placed in a very eye-catching location inside her home. Being a maid, she's hesitant to ask her master to go swimming with her for fear of making a faux pas. So instead, you should be the one to ask her.",
		model = {
			"no_bake_prop/pre_db_toy02"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_toy02/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bath",
		name = "Box of Books",
		award = 0,
		time = 0,
		id = 22,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item31",
		desc = "A storage box for regular workbooks. Sirius says the notepads outline her maidly work schedules. You see half-faded writing on the label on the cover. \"The Ways I Want to Be --------\" it says – half of the title has been almost completely erased.",
		model = {
			"no_bake_prop/pre_db_paperskin01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_paperskin01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bath",
		name = "Watering Pot",
		award = 0,
		time = 0,
		id = 23,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item27",
		desc = "A watering can keeps the potted plants and flowers around the room happy. This is not a watering can. It's very blatantly a teapot. You wonder what bizarre thinking led Sirius to start using this in place of a proper watering can.",
		model = {
			"no_bake_prop/pre_db_smalltool02"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_smalltool02/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Nightlight",
		award = 0,
		time = 2,
		id = 24,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item32",
		desc = "A nightlight with an endearing design.Sirius got it so she wouldn't trip and fall when she gets up at night.Its warm light reminds you of the warmth of her smile.",
		model = {
			"no_bake_prop/pre_db_desklamp02"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_desklamp02/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Sunglasses",
		award = 0,
		time = 2,
		id = 25,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item33",
		desc = "The pair of sunglasses Sirius brought with her to the beach.She leaves them where they're always in reach.",
		model = {
			"no_bake_prop/pre_db_glasses01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_glasses01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bath",
		name = "Body Lotion",
		award = 0,
		time = 2,
		id = 26,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item34",
		desc = "Sirius uses this body lotion after her baths.Sometimes, you can smell its faint aroma even from the door to her quarters.",
		model = {
			"no_bake_prop/pre_db_cosmetic15"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_cosmetic15/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "Aroma Diffuser",
		award = 0,
		time = 2,
		id = 27,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item35",
		desc = "This diffuser exudes a mild floral scent. Sirius chose it with great care.The aroma supposedly relieves stress and helps the mind relax.",
		model = {
			"no_bake_prop/pre_db_cosmetic14"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_cosmetic14/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_chair",
		name = "White Towel",
		award = 0,
		time = 2,
		id = 28,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item36",
		desc = "This white towel was haphazardly left here. It's still slightly moist to the touch.Maybe Sirius just got done in the bathroom? Who knows.",
		model = {
			"no_bake_prop/pre_db_towel10"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_towel10/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_bed",
		name = "How to Win Your Commander's Heart - Volume 2",
		award = 0,
		time = 2,
		id = 29,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item37",
		desc = "A book Sirius left by her bedside.What is this book doing here?Also, they made TWO volumes of this?",
		model = {
			"no_bake_prop/pre_db_book10"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_book10/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_sirius_chair",
		name = "Half-Drunk Milk",
		award = 0,
		time = 2,
		id = 30,
		room_id = 1,
		icon = "3Ddrom_tianlangxing_item38",
		desc = "Half full, or half empty? Either way, it's sitting on the table and has faint lip markings along its rim.",
		model = {
			"no_bake_prop/pre_db_drink01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_drink01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_collection_beach",
		name = "Splendid Sandcastle",
		award = 0,
		time = 0,
		id = 31,
		room_id = 4,
		icon = "3Ddrom_beach_item1",
		desc = "This sandcastle shines golden under the sun. Its builder put clear effort into everything down to the smallest details.You can readily picture just how much work was put into it.Here's hoping that the waves won't wash it away.",
		model = {
			"no_bake_prop/pre_dp_toy05_01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_dp_toy05_01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_collection_beach",
		name = "Beach Tools",
		award = 0,
		time = 0,
		id = 32,
		room_id = 4,
		icon = "3Ddrom_beach_item2",
		desc = "A shovel and a bucket lying in the sand. Looks like someone was using them until just a minute ago.You think to yourself that maybe you should have a sandcastle-building contest next time you visit the beach with someone.",
		model = {
			"no_bake_prop/pre_db_smalltool09_01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_smalltool09_01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_collection_beach",
		name = "Seabreeze Guitar",
		award = 0,
		time = 0,
		id = 33,
		room_id = 4,
		icon = "3Ddrom_beach_item3",
		desc = "A wooden guitar, forgotten and left behind by its own. Brine lingers inside its cavity, and it smells like the sea. Its notes sound almost like the lapping of waves on a beach.",
		model = {
			"no_bake_prop/pre_guitar02"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_guitar02/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_collection_beach",
		name = "Half-Consumed Drink",
		award = 0,
		time = 0,
		id = 34,
		room_id = 4,
		icon = "3Ddrom_beach_item4",
		desc = "A partially drunk beverage. It's still cold, with drops of condensation gently running down its sides. Whoever this belonged to earlier, the beached has claimed it now.",
		model = {
			"no_bake_prop/pre_db_drink06_01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_drink06_01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_collection_beach",
		name = "Surfboards",
		award = 0,
		time = 0,
		id = 35,
		room_id = 4,
		icon = "3Ddrom_beach_item5",
		desc = "These surfboards have been casually left here. Their many scratches whisper stories about past encounters with fierce waves. Maybe you should go surfing the next time you visit the beach with someone.",
		model = {
			"no_bake_prop/pre_db_sportinggoods04a_01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_sportinggoods04a_01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_collection_beach",
		name = "Cooler",
		award = 0,
		time = 0,
		id = 36,
		room_id = 4,
		icon = "3Ddrom_beach_item6",
		desc = "A cute little cooler. Someone must have packed for some sort of party, because it's stuffed full of drinks and snacks. You can't help but wonder where its owner has gone.",
		model = {
			"fbx/litmap06/box/pre_plasticbox01_2"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap06/box/pre_plasticbox01_2/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_collection_beach",
		name = "Inner Tubes",
		award = 0,
		time = 0,
		id = 37,
		room_id = 4,
		icon = "3Ddrom_beach_item7",
		desc = "Two inner tubes, one in blue and one in yellow, silently resting on the beach. While they look pretty old, they are still able to do their job perfectly well.",
		model = {
			"no_bake_prop/pre_db_sportinggoods02_01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_sportinggoods02_01/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_collection_beach",
		name = "Trash Can",
		award = 0,
		time = 0,
		id = 38,
		room_id = 4,
		icon = "3Ddrom_beach_item8",
		desc = "A trash can with a humble design. Remember: don't litter on the beach! Keeping it clean is just as important as keeping the oceans clean.",
		model = {
			"no_bake_prop/pre_db_trashcan02"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"no_bake_prop/pre_db_trashcan02/vfx_wupintishi01"
		}
	},
	{
		text = "dorm3d_collection_beach",
		name = "Lantern",
		award = 0,
		time = 0,
		id = 39,
		room_id = 4,
		icon = "3Ddrom_beach_item9",
		desc = "A lantern with a simple design. When it gets dark at the beach, this can be a real lifesaver. It's all but begging to be brought along on a fantastical nightly stroll along the sea.",
		model = {
			"fbx/litmap04/pre_desklamp01"
		},
		unlock = {
			1,
			20220,
			1
		},
		vfx_prefab = {
			"fbx/litmap04/pre_desklamp01/vfx_wupintishi01"
		}
	},
	[51] = {
		text = "dorm3d_noshiro_chair",
		name = "Hanami Dango Plate",
		award = 0,
		time = 0,
		id = 51,
		room_id = 2,
		icon = "3Ddrom_nengdai_item1",
		desc = "The delectable dango rest quietly on a ceramic plate,\nperfectly complementing the tablecloth's design.\nEnjoy them with her later.",
		model = {
			"fbx/no_bake_pay_prop/livingroom/table/pre_db_tableware14"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/no_bake_pay_prop/livingroom/table/pre_db_tableware14/vfx_wupintishi01"
		}
	},
	[52] = {
		text = "dorm3d_noshiro_chair",
		name = "Tri-Color Mochi",
		award = 0,
		time = 0,
		id = 52,
		room_id = 2,
		icon = "3Ddrom_nengdai_item2",
		desc = "Green grass, white snow, peach blossoms;\nhealth, purity, protection;\nsoft and chewy, filled with her heartfelt wishes...",
		model = {
			"fbx/no_bake_pay_prop/livingroom/table/pre_db_tableware15"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/no_bake_pay_prop/livingroom/table/pre_db_tableware15/vfx_wupintishi01"
		}
	},
	[53] = {
		text = "dorm3d_noshiro_bed",
		name = "Opened Book",
		award = 0,
		time = 1,
		id = 53,
		room_id = 2,
		icon = "3Ddrom_nengdai_item3",
		desc = "A book on traditional Sakuran tea ceremonies,\nits corners slightly weathered.\nNoshiro appears to revisit this book often,\nleaving many neat notes on the last pages.",
		model = {
			"fbx/litmap_03/day/pre_db_book01"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/day/pre_db_book01/vfx_wupintishi01"
		}
	},
	[54] = {
		text = "dorm3d_noshiro_bed",
		name = "Bedding",
		award = 0,
		time = 0,
		id = 54,
		room_id = 2,
		icon = "3Ddrom_nengdai_item4",
		desc = "Neatly folded bedding.\nThe precise corners are a testament to its owner's diligence.",
		model = {
			"fbx/litmap_04/pre_db_quilt01"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_04/pre_db_quilt01/vfx_wupintishi01"
		}
	},
	[55] = {
		text = "dorm3d_noshiro_bed",
		name = "Uniform",
		award = 0,
		time = 0,
		id = 55,
		room_id = 2,
		icon = "3Ddrom_nengdai_item5",
		desc = "The uniform hanging on the wall is the same as the one she is wearing.\nLooks like this is the outfit she likes the most.",
		model = {
			"fbx/litmap_03/pre_db_cloth02_01"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_cloth02_01/vfx_wupintishi01"
		}
	},
	[56] = {
		text = "dorm3d_noshiro_chair",
		name = "Sakuran Sweets",
		award = 0,
		time = 0,
		id = 56,
		room_id = 2,
		icon = "3Ddrom_nengdai_item6",
		desc = "A beautifully arranged assortment of Sakuran sweets, each handmade by Noshiro.\nThough they may almost be too pretty to eat,\nbe sure to savor them later – lest her hard work will go to waste!",
		model = {
			"fbx/no_bake_pay_prop/livingroom/table/pre_db_tableware13"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/no_bake_pay_prop/livingroom/table/pre_db_tableware13/vfx_wupintishi01"
		}
	},
	[57] = {
		text = "dorm3d_noshiro_chair",
		name = "Wind Chime",
		award = 0,
		time = 0,
		id = 57,
		room_id = 2,
		icon = "3Ddrom_nengdai_item7",
		desc = "A wind chime hangs by the window,\nproducing a clear melody as the breeze passes through.\nAccording to Noshiro, it's one of the best ways to beat the summer heat.",
		model = {
			"fbx/litmap_03/pre_db_curtain04"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_curtain04/vfx_wupintishi01"
		}
	},
	[58] = {
		text = "dorm3d_noshiro_table",
		name = "Wind Chime 2",
		award = 0,
		time = 0,
		id = 58,
		room_id = 2,
		icon = "3Ddrom_nengdai_item8",
		desc = "This wind chime produces a deeper tone than the glass one.\nNoshiro has purposefully hung it up elsewhereso the different notes interweave, creating a unique mood.",
		model = {
			"fbx/litmap_03/pre_db_decoration06"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_decoration06/vfx_wupintishi01"
		}
	},
	[59] = {
		text = "dorm3d_noshiro_table",
		name = "Shopping Bag",
		award = 0,
		time = 0,
		id = 59,
		room_id = 2,
		icon = "3Ddrom_nengdai_item9",
		desc = "A paper bag bearing a coffee shop logo.\nNoshiro treats it with great care,\nmore than you'd expect for a regular paper bag.",
		model = {
			"fbx/litmap_03/pre_db_bag01"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_bag01/vfx_wupintishi01"
		}
	},
	[60] = {
		text = "dorm3d_noshiro_bed",
		name = "Sakuran Kimono",
		award = 0,
		time = 0,
		id = 60,
		room_id = 2,
		icon = "3Ddrom_nengdai_item10",
		desc = "The gold-thread embroidery on this kimono's sleeves speaks of its elegance.\nIt's Noshiro's favorite.\nShe always conducts herself carefully when she wears it outside.",
		model = {
			"fbx/litmap_03/pre_db_frame06"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_frame06/vfx_wupintishi01"
		}
	},
	[61] = {
		text = "dorm3d_noshiro_chair",
		name = "Preserved Flowers",
		award = 0,
		time = 0,
		id = 61,
		room_id = 2,
		icon = "3Ddrom_nengdai_item11",
		desc = "Yellow roses carefully preserved inside a bell jar.\nThe petals retain their vivid color even to this day.",
		model = {
			"fbx/litmap_03/day/pre_db_decoration07"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/day/pre_db_decoration07/vfx_wupintishi01"
		}
	},
	[62] = {
		text = "dorm3d_noshiro_chair",
		name = "Pine Bonsai",
		award = 0,
		time = 0,
		id = 62,
		room_id = 2,
		icon = "3Ddrom_nengdai_item12",
		desc = "A small pine tree bonsai.\nThe branches have been trimmed in a plain yet tasteful way.\nNoshiro tends to it daily, preserving its natural beauty in perfect form.",
		model = {
			"fbx/litmap_03/pre_db_bonsai03_01"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_bonsai03_01/vfx_wupintishi01"
		}
	},
	[63] = {
		text = "dorm3d_noshiro_chair",
		name = "Water Ornament",
		award = 0,
		time = 0,
		id = 63,
		room_id = 2,
		icon = "3Ddrom_nengdai_item13",
		desc = "A Sakuran ornament that typically goes in the garden but, in this case, has been placed in a corner of the room.\nWhen water flows in, it produces a clear and pleasant sound.",
		model = {
			"fbx/litmap_03/pre_db_noshirohostel01_02"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_noshirohostel01_02/vfx_wupintishi01"
		}
	},
	[64] = {
		text = "dorm3d_noshiro_table",
		name = "Sakuran Umbrella",
		award = 0,
		time = 0,
		id = 64,
		room_id = 2,
		icon = "3Ddrom_nengdai_item14",
		desc = "This folded umbrella rests against the wall.\nNoshiro often carries it with her when she goes outside.\nWhen it's raining, obviously.",
		model = {
			"fbx/litmap_03/pre_db_decoration05_01"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_decoration05_01/vfx_wupintishi01"
		}
	},
	[65] = {
		text = "dorm3d_noshiro_chair",
		name = "Round Cushion",
		award = 0,
		time = 0,
		id = 65,
		room_id = 2,
		icon = "3Ddrom_nengdai_item15",
		desc = "A round cushion in a bright color.\nWhile it looks firm at a glance, it's surprisingly comfy to sit on.\nMaybe you should put one in your office too?",
		model = {
			"fbx/no_bake_pay_prop/livingroom/table/pre_db_chair08"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/no_bake_pay_prop/livingroom/table/pre_db_chair08/vfx_wupintishi01"
		}
	},
	[66] = {
		text = "dorm3d_noshiro_table",
		name = "Sushi Platter",
		award = 0,
		time = 0,
		id = 66,
		room_id = 2,
		icon = "3Ddrom_nengdai_item16",
		desc = "A tray lined with hand-formed sushi and other delicacies.\nEvery item is meticulously placed,\nand even the decorative elements are well-thought-out.\nSurprisingly, sushi rolls are even included.\nTurns out Noshiro isn't a stickler for tradition.",
		model = {
			"fbx/no_bake_pay_prop/diningroom/pre_db_tableware12_01"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/no_bake_pay_prop/diningroom/pre_db_tableware12_01/vfx_wupintishi01"
		}
	},
	[67] = {
		text = "dorm3d_noshiro_chair",
		name = "Cherry Blossom Branch",
		award = 0,
		time = 0,
		id = 67,
		room_id = 2,
		icon = "3Ddrom_nengdai_item17",
		desc = "A cherry blossom branch left on the table.\nThe pink petals almost glow on the branch, lending a touch of spring mood.",
		model = {
			"fbx/no_bake_pay_prop/livingroom/table/pre_db_flowers04"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/no_bake_pay_prop/livingroom/table/pre_db_flowers04/vfx_wupintishi01"
		}
	},
	[68] = {
		text = "dorm3d_noshiro_bed",
		name = "Stack of Books",
		award = 0,
		time = 0,
		id = 68,
		room_id = 2,
		icon = "3Ddrom_nengdai_item18",
		desc = "A stack of books piled atop one another.\nThe subjects covered range from tea ceremonies to flower arrangement and traditional etiquette.\nBased on where the bookmark is, Noshiro is studying a new flower arrangement technique.",
		model = {
			"fbx/litmap_03/pre_db_book04_01"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_book04_01/vfx_wupintishi01"
		}
	},
	[70] = {
		text = "dorm3d_noshiro_bed",
		name = "Kettle",
		award = 0,
		time = 0,
		id = 70,
		room_id = 2,
		icon = "3Ddrom_nengdai_item19",
		desc = "An unremarkable kettle.\nNoshiro often uses it when making tea.\nDespite its signs of heavy use, it's still in good condition thanks to diligent care.",
		model = {
			"fbx/litmap_02/pre_db_tableware09"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_02/pre_db_tableware09/vfx_wupintishi01"
		}
	},
	[72] = {
		text = "dorm3d_noshiro_bed",
		name = "Tied Hanging Scrolls",
		award = 0,
		time = 0,
		id = 72,
		room_id = 2,
		icon = "3Ddrom_nengdai_item20",
		desc = "These scrolls rest quietly in the corner of the study,\ntheir knots perfectly tied.\nThough not unfurled, they still convey Noshiro's meticulous care.",
		model = {
			"fbx/litmap_03/pre_db_cupboard08_01"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/pre_db_cupboard08_01/vfx_wupintishi01"
		}
	},
	[71] = {
		text = "dorm3d_sirius_chair",
		name = "Stone Lantern",
		award = 0,
		time = 1,
		id = 71,
		room_id = 2,
		icon = "3Ddrom_nengdai_item21",
		desc = "A lantern made of stone, inspired by traditional Sakuran garden lanterns.\nIt lends an air of tranquility to wherever it's placed.",
		model = {
			"fbx/litmap_03/day/pre_db_noshirohostel01_lamp02"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/day/pre_db_noshirohostel01_lamp02/vfx_wupintishi01"
		}
	},
	[76] = {
		text = "dorm3d_noshiro_bed",
		name = "Humidifier",
		award = 0,
		time = 2,
		id = 76,
		room_id = 2,
		icon = "3Ddrom_nengdai_item24",
		desc = "This white humidifier operates silently most of the time,\nonly sometimes making a faint hum.\nNoshiro placed it in a corner where it can slowly release moist air.\nShe says it's good for her skin.",
		model = {
			"fbx/litmap_03/night/pre_db_electrical08"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/night/pre_db_electrical08/vfx_wupintishi01"
		}
	},
	[77] = {
		text = "dorm3d_noshiro_bed",
		name = "Skincare Oil",
		award = 0,
		time = 2,
		id = 77,
		room_id = 2,
		icon = "3Ddrom_nengdai_item25",
		desc = "The oil inside the bottle emits a delicate fragrance.\nAccording to Noshiro, it's extracted from camellias.\nIt's one of her favorite skincare products.",
		model = {
			"fbx/litmap_03/night/pre_db_cosmetic10"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/night/pre_db_cosmetic10/vfx_wupintishi01"
		}
	},
	[78] = {
		text = "dorm3d_noshiro_bed",
		name = "Perfume Bottle",
		award = 0,
		time = 2,
		id = 78,
		room_id = 2,
		icon = "3Ddrom_nengdai_item26",
		desc = "A bottle of perfume with a simple design.\nLight softly reflects off its glass surface.\nUpon closer inspection, you notice that this is the very bottle you gifted her.",
		model = {
			"fbx/litmap_03/night/pre_db_cosmetic01_01/pre_db_cosmetic01c"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/night/pre_db_cosmetic01_01/pre_db_cosmetic01c/vfx_wupintishi01"
		}
	},
	[79] = {
		text = "dorm3d_noshiro_bed",
		name = "Reed Diffuser",
		award = 0,
		time = 2,
		id = 79,
		room_id = 2,
		icon = "3Ddrom_nengdai_item27",
		desc = "A diffuser with a delicate fragrance.\nIts subtle aroma fills the room.\nIt's the scent that always lingers around Noshiro.",
		model = {
			"fbx/litmap_04/night/pre_db_cosmetic02a_01"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_04/night/pre_db_cosmetic02a_01/vfx_wupintishi01"
		}
	},
	[74] = {
		text = "dorm3d_noshiro_bed",
		name = "Wooden Lantern",
		award = 0,
		time = 2,
		id = 74,
		room_id = 2,
		icon = "3Ddrom_nengdai_item23",
		desc = "A square, wooden lantern that's been placed in a corner.\nA soft light glows through the translucent paper.\nNoshiro picked this furnishing after careful deliberation.",
		model = {
			"fbx/litmap_03/night/pre_db_chandelier11_on"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/litmap_03/night/pre_db_chandelier11_on/vfx_wupintishi01"
		}
	},
	[75] = {
		text = "dorm3d_noshiro_chair",
		name = "Floor Lamp",
		award = 0,
		time = 2,
		id = 75,
		room_id = 2,
		icon = "3Ddrom_nengdai_item22",
		desc = "An austere Sakuran-style floor lamp. It glows with a soft light.\nBeneath its shade hangs a delicate wind chime ornament.\nIt creates a quiet, serene space where you can spend a peaceful time with Noshiro.",
		model = {
			"fbx/no_bake_pay_prop/livingroom/pre_db_chandelier08_on"
		},
		unlock = {
			1,
			30221,
			1
		},
		vfx_prefab = {
			"fbx/no_bake_pay_prop/livingroom/pre_db_chandelier08_on/vfx_wupintishi01"
		}
	}
}
