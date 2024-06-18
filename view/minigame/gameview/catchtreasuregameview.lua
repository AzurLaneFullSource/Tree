local var0_0 = class("CatchTreasureGameView", import("..BaseMiniGameView"))
local var1_0 = "blueocean-image"
local var2_0 = "event:/ui/ddldaoshu2"
local var3_0 = "event:/ui/taosheng"
local var4_0 = "event:/ui/zhuahuo"
local var5_0 = "event:/ui/deshou"
local var6_0 = "event:/ui/shibai"
local var7_0 = 60
local var8_0 = "ui/catchtreasuregameui_atlas"
local var9_0 = "salvage_tips"
local var10_0 = "event item done"
local var11_0 = "boat state stand"
local var12_0 = "boat state thorw"
local var13_0 = "boat state wait"
local var14_0 = "item act static"
local var15_0 = "item act dynamic"
local var16_0 = "item catch normal"
local var17_0 = "item catch release"
local var18_0 = "item catch unable"
local var19_0 = "item good happy"
local var20_0 = "item good surprise"
local var21_0 = "item good release"
local var22_0 = "item good none"
local var23_0 = "item scene back"
local var24_0 = "item scene middle"
local var25_0 = "item scene front"
local var26_0 = "item type fish"
local var27_0 = "item type submarine"
local var28_0 = "item type goods"
local var29_0 = "item type sundries"
local var30_0 = "item type time"
local var31_0 = "item type back"
local var32_0 = "item type bind"
local var33_0 = "item type name "
local var34_0 = {
	{
		type = var14_0,
		range = {
			5,
			8
		}
	},
	{
		type = var15_0,
		range = {
			5,
			8
		}
	}
}
local var35_0 = {
	{
		{
			repeated = true,
			type = var31_0,
			amount = {
				8,
				10
			}
		},
		{
			repeated = true,
			type = var28_0,
			amount = {
				6,
				6
			},
			name = {
				"treasure",
				"gold"
			}
		},
		{
			repeated = true,
			type = var28_0,
			amount = {
				2,
				2
			},
			name = {
				"rock"
			}
		},
		{
			repeated = true,
			type = var28_0,
			amount = {
				4,
				4
			},
			name = {
				"shell"
			}
		},
		{
			repeated = true,
			type = var29_0,
			amount = {
				3,
				3
			}
		},
		{
			repeated = true,
			type = var30_0,
			amount = {
				2,
				2
			}
		},
		{
			repeated = true,
			type = var26_0,
			amount = {
				2,
				2
			},
			name = {
				"fish_1",
				"fish_2",
				"fish_3",
				"fish_4"
			}
		},
		{
			repeated = true,
			type = var26_0,
			amount = {
				1,
				1
			},
			name = {
				"turtle"
			}
		},
		{
			repeated = false,
			type = var27_0,
			amount = {
				1,
				1
			},
			name = {
				"submarine_1"
			}
		},
		{
			repeated = false,
			type = var27_0,
			amount = {
				0,
				0
			},
			name = {
				"submarine_2"
			}
		},
		{
			repeated = false,
			type = var27_0,
			amount = {
				0,
				0
			},
			name = {
				"submarine_3"
			}
		},
		{
			repeated = false,
			type = var27_0,
			amount = {
				1,
				1
			},
			name = {
				"submarine_4"
			}
		}
	},
	{
		{
			repeated = true,
			type = var31_0,
			amount = {
				8,
				10
			}
		},
		{
			repeated = true,
			type = var28_0,
			amount = {
				2,
				2
			},
			name = {
				"treasure",
				"gold",
				"shell"
			}
		},
		{
			repeated = true,
			type = var28_0,
			amount = {
				0,
				0
			},
			name = {
				"rock"
			}
		},
		{
			repeated = true,
			type = var29_0,
			amount = {
				0,
				0
			}
		},
		{
			repeated = true,
			type = var30_0,
			amount = {
				2,
				2
			}
		},
		{
			repeated = true,
			type = var26_0,
			amount = {
				2,
				2
			},
			name = {
				"fish_1",
				"fish_4"
			}
		},
		{
			repeated = true,
			type = var26_0,
			amount = {
				3,
				3
			},
			name = {
				"fish_2"
			}
		},
		{
			repeated = true,
			type = var26_0,
			amount = {
				6,
				6
			},
			name = {
				"fish_3"
			}
		},
		{
			repeated = true,
			type = var26_0,
			amount = {
				5,
				5
			},
			name = {
				"turtle"
			}
		},
		{
			repeated = false,
			type = var27_0,
			amount = {
				0,
				0
			},
			name = {
				"submarine_1"
			}
		},
		{
			repeated = false,
			type = var27_0,
			amount = {
				1,
				1
			},
			name = {
				"submarine_2"
			}
		},
		{
			repeated = false,
			type = var27_0,
			amount = {
				1,
				1
			},
			name = {
				"submarine_3"
			}
		},
		{
			repeated = false,
			type = var27_0,
			amount = {
				0,
				0
			},
			name = {
				"submarine_4"
			}
		}
	},
	{
		{
			repeated = true,
			type = var31_0,
			amount = {
				8,
				10
			}
		},
		{
			repeated = true,
			type = var28_0,
			amount = {
				2,
				2
			},
			name = {
				"treasure"
			}
		},
		{
			repeated = true,
			type = var28_0,
			amount = {
				1,
				1
			},
			name = {
				"rock"
			}
		},
		{
			repeated = true,
			type = var28_0,
			amount = {
				2,
				2
			},
			name = {
				"gold"
			}
		},
		{
			repeated = true,
			type = var28_0,
			amount = {
				2,
				2
			},
			name = {
				"shell"
			}
		},
		{
			repeated = true,
			type = var29_0,
			amount = {
				1,
				1
			}
		},
		{
			repeated = true,
			type = var30_0,
			amount = {
				2,
				2
			}
		},
		{
			repeated = true,
			type = var26_0,
			amount = {
				2,
				2
			},
			name = {
				"fish_1",
				"fish_4"
			}
		},
		{
			repeated = true,
			type = var26_0,
			amount = {
				2,
				2
			},
			name = {
				"fish_2"
			}
		},
		{
			repeated = true,
			type = var26_0,
			amount = {
				3,
				3
			},
			name = {
				"fish_3"
			}
		},
		{
			repeated = true,
			type = var26_0,
			amount = {
				2,
				2
			},
			name = {
				"turtle"
			}
		},
		{
			repeated = false,
			type = var27_0,
			amount = {
				3,
				3
			},
			name = {
				"submarine_1",
				"submarine_2",
				"submarine_3",
				"submarine_4"
			}
		}
	}
}
local var36_0 = {
	{
		score = 200,
		name = "fish_1",
		catch_speed = 130,
		speed = 150,
		release_speed = 200,
		type = var26_0,
		act = var15_0,
		catch = var17_0,
		create_range = {
			0,
			9999,
			130,
			260
		},
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21_0
	},
	{
		score = 250,
		name = "fish_2",
		catch_speed = 75,
		speed = 100,
		leave_direct = -1,
		release_speed = 200,
		type = var26_0,
		act = var15_0,
		catch = var17_0,
		create_range = {
			0,
			9999,
			130,
			260
		},
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var20_0
	},
	{
		score = 400,
		name = "fish_3",
		catch_speed = 220,
		speed = 350,
		release_speed = 300,
		type = var26_0,
		act = var15_0,
		catch = var17_0,
		create_range = {
			0,
			9999,
			130,
			260
		},
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21_0
	},
	{
		score = 150,
		name = "fish_4",
		catch_speed = 160,
		speed = 120,
		release_speed = 200,
		type = var26_0,
		act = var15_0,
		catch = var17_0,
		create_range = {
			0,
			9999,
			130,
			260
		},
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21_0
	},
	{
		score = 180,
		name = "turtle",
		catch_speed = 100,
		speed = 80,
		release_speed = 100,
		type = var26_0,
		act = var15_0,
		catch = var17_0,
		create_range = {
			0,
			9999,
			130,
			260
		},
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21_0
	},
	{
		score = -150,
		name = "submarine_1",
		speed = 200,
		catch_speed = 100,
		release_speed = 200,
		type = var27_0,
		act = var15_0,
		catch = var17_0,
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21_0,
		interaction = {
			time = {
				3,
				7
			},
			parame = {
				"swim"
			}
		}
	},
	{
		score = -100,
		name = "submarine_2",
		speed = 150,
		catch_speed = 100,
		release_speed = 200,
		type = var27_0,
		act = var15_0,
		catch = var17_0,
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21_0,
		interaction = {
			time = {
				3,
				7
			},
			parame = {
				"swim"
			}
		}
	},
	{
		score = -80,
		name = "submarine_3",
		speed = 120,
		catch_speed = 100,
		release_speed = 200,
		type = var27_0,
		act = var15_0,
		catch = var17_0,
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21_0,
		interaction = {
			time = {
				3,
				7
			},
			parame = {
				"swim"
			}
		}
	},
	{
		score = -50,
		name = "submarine_4",
		speed = 90,
		catch_speed = 100,
		release_speed = 200,
		type = var27_0,
		act = var15_0,
		catch = var17_0,
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21_0,
		interaction = {
			time = {
				3,
				7
			},
			parame = {
				"swim"
			}
		}
	},
	{
		score = -50,
		name = "boom",
		speed = 500,
		catch_speed = 300,
		type = var29_0,
		act = var15_0,
		catch = var16_0,
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var20_0
	},
	{
		speed = 0,
		name = "rock",
		score = 50,
		catch_speed = 80,
		type = var28_0,
		act = var14_0,
		catch = var16_0,
		good = var22_0
	},
	{
		score = 300,
		name = "gold",
		speed = 0,
		catch_speed = 160,
		type = var28_0,
		act = var14_0,
		catch = var16_0,
		create_range = {
			0,
			9999,
			0,
			130
		},
		good = var19_0
	},
	{
		score = 600,
		name = "treasure",
		speed = 0,
		catch_speed = 55,
		type = var28_0,
		act = var14_0,
		catch = var16_0,
		create_range = {
			0,
			9999,
			0,
			130
		},
		good = var19_0
	},
	{
		score = 600,
		name = "watch",
		time = 20,
		catch_speed = 180,
		speed = 0,
		type = var30_0,
		act = var14_0,
		catch = var16_0,
		create_range = {
			0,
			9999,
			0,
			130
		},
		good = var19_0
	},
	{
		score = 200,
		name = "shell",
		speed = 0,
		catch_speed = 100,
		type = var28_0,
		act = var14_0,
		catch = var16_0,
		create_range = {
			0,
			9999,
			0,
			130
		},
		good = var19_0,
		catch_rule = {
			targetName = "pearl",
			state = {
				1
			}
		},
		anim_data = {
			state_change = {
				1,
				2
			},
			time = {
				3,
				5
			}
		}
	},
	{
		speed = 0,
		name = "pearl",
		score = 500,
		catch_speed = 200,
		type = var32_0,
		act = var14_0,
		catch = var16_0,
		good = var19_0
	},
	{
		speed = 30,
		name = "Anglerfish",
		direct = -1,
		type = var31_0,
		act = var15_0,
		scene = var23_0,
		catch = var18_0,
		create_range = {
			-9999,
			9999,
			130,
			600
		},
		move_range = {
			-400,
			1800,
			0,
			0
		}
	},
	{
		speed = 20,
		name = "Fish_A",
		direct = -1,
		type = var31_0,
		act = var15_0,
		scene = var23_0,
		catch = var18_0,
		create_range = {
			-9999,
			9999,
			130,
			600
		},
		move_range = {
			-400,
			1800,
			0,
			0
		}
	},
	{
		speed = 20,
		name = "Fish_B",
		direct = -1,
		type = var31_0,
		act = var15_0,
		scene = var23_0,
		catch = var18_0,
		create_range = {
			-9999,
			9999,
			130,
			600
		},
		move_range = {
			-400,
			1800,
			0,
			0
		}
	},
	{
		speed = 20,
		name = "Fish_C",
		direct = -1,
		type = var31_0,
		act = var15_0,
		scene = var23_0,
		catch = var18_0,
		create_range = {
			-9999,
			9999,
			130,
			600
		},
		move_range = {
			-400,
			1800,
			0,
			0
		}
	},
	{
		speed = 10,
		name = "Fish_D",
		direct = -1,
		type = var31_0,
		act = var15_0,
		scene = var23_0,
		catch = var18_0,
		create_range = {
			-9999,
			9999,
			130,
			600
		},
		move_range = {
			-400,
			1800,
			0,
			0
		}
	},
	{
		speed = 30,
		name = "Fish_E",
		direct = -1,
		type = var31_0,
		act = var15_0,
		scene = var23_0,
		catch = var18_0,
		create_range = {
			-9999,
			9999,
			130,
			600
		},
		move_range = {
			-400,
			1800,
			0,
			0
		}
	},
	{
		speed = 20,
		name = "Fish_manjuu",
		direct = -1,
		type = var31_0,
		act = var15_0,
		scene = var23_0,
		catch = var18_0,
		create_range = {
			-9999,
			9999,
			130,
			600
		},
		move_range = {
			-400,
			1800,
			0,
			0
		}
	},
	{
		speed = 30,
		name = "Seal",
		direct = -1,
		type = var31_0,
		act = var15_0,
		scene = var23_0,
		catch = var18_0,
		create_range = {
			-9999,
			9999,
			130,
			600
		},
		move_range = {
			-400,
			1800,
			0,
			0
		}
	},
	{
		speed = 30,
		name = "Submarine",
		direct = -1,
		type = var31_0,
		act = var15_0,
		scene = var23_0,
		catch = var18_0,
		create_range = {
			-9999,
			9999,
			130,
			600
		},
		move_range = {
			-400,
			1800,
			0,
			0
		}
	},
	{
		speed = 30,
		name = "Sunfish",
		direct = -1,
		type = var31_0,
		act = var15_0,
		scene = var23_0,
		catch = var18_0,
		create_range = {
			-9999,
			9999,
			130,
			600
		},
		move_range = {
			-400,
			1800,
			0,
			0
		}
	}
}
local var37_0 = 500
local var38_0 = 300
local var39_0 = 200
local var40_0 = 200
local var41_0 = 45
local var42_0 = 2.5
local var43_0 = 50
local var44_0 = 100
local var45_0 = 580
local var46_0 = 130
local var47_0 = {
	{
		color = "8dff1e",
		font = 44,
		score = 500
	},
	{
		color = "d0fb09",
		font = 44,
		score = 400
	},
	{
		color = "ffec1e",
		font = 44,
		score = 300
	},
	{
		score = 200,
		color = "fcdc2a"
	},
	{
		score = 100,
		color = "f1b524"
	},
	{
		score = 0,
		color = "ffa024"
	},
	{
		score = -100,
		color = "680c00"
	},
	{
		score = -200,
		color = "6f1807"
	}
}
local var48_0 = "char apply position"
local var49_0 = "char apply move"
local var50_0 = "char apply act"
local var51_0 = {
	{
		speed = 3,
		id = 1,
		tf = "Shiratsuyu",
		bindIds = {
			2
		},
		actions = {
			{
				posX = -1200,
				type = var48_0
			},
			{
				trigger = "moveA",
				type = var50_0
			},
			{
				sync = true,
				offsetX = -50,
				direct = -1,
				type = var49_0,
				moveToX = {
					300,
					400
				}
			},
			{
				time = 2,
				trigger = "actA",
				type = var50_0
			},
			{
				time = 2,
				trigger = "actB",
				type = var50_0
			},
			{
				time = 0,
				trigger = "moveB",
				type = var50_0
			},
			{
				direct = -1,
				type = var49_0,
				moveToX = {
					2000,
					2000
				}
			}
		}
	},
	{
		id = 2,
		speed = 3,
		tf = "Shigure",
		actions = {
			{
				posX = 1200,
				type = var48_0
			},
			{
				trigger = "moveA",
				type = var50_0
			},
			{
				sync = true,
				offsetX = 50,
				direct = -1,
				type = var49_0
			},
			{
				time = 2,
				trigger = "actA",
				type = var50_0
			},
			{
				time = 2,
				trigger = "actB",
				type = var50_0
			},
			{
				time = 0,
				trigger = "moveB",
				type = var50_0
			},
			{
				direct = -1,
				type = var49_0,
				moveToX = {
					2100,
					2200
				}
			}
		}
	},
	{
		id = 3,
		speed = 2,
		tf = "eldridge",
		actions = {
			{
				posX = -1200,
				type = var48_0
			},
			{
				trigger = "move",
				type = var50_0
			},
			{
				direct = -1,
				type = var49_0,
				moveToX = {
					100,
					300
				}
			},
			{
				trigger = "act",
				type = var50_0
			},
			{
				direct = -1,
				type = var49_0,
				moveToX = {
					600,
					700
				}
			},
			{
				trigger = "act",
				type = var50_0
			},
			{
				direct = -1,
				type = var49_0,
				moveToX = {
					1300,
					1300
				}
			}
		}
	},
	{
		id = 4,
		speed = 4,
		tf = "bombBoat",
		actions = {
			{
				posX = 1200,
				type = var48_0
			},
			{
				trigger = "move",
				type = var50_0
			},
			{
				direct = -1,
				type = var49_0,
				moveToX = {
					-1100,
					-1300
				}
			}
		}
	},
	{
		id = 5,
		speed = 3,
		tf = "Fleet",
		actions = {
			{
				posX = -1200,
				type = var48_0
			},
			{
				trigger = "move",
				type = var50_0
			},
			{
				direct = -1,
				type = var49_0,
				moveToX = {
					500,
					700
				}
			},
			{
				time = 4,
				trigger = "act",
				type = var50_0
			},
			{
				direct = -1,
				type = var49_0,
				moveToX = {
					1300,
					1500
				}
			}
		}
	},
	{
		id = 6,
		speed = 4,
		tf = "Glowworm",
		actions = {
			{
				posX = 1200,
				type = var48_0
			},
			{
				trigger = "move",
				type = var50_0
			},
			{
				direct = -1,
				type = var49_0,
				moveToX = {
					-550,
					-1000
				}
			},
			{
				time = 2,
				trigger = "act",
				type = var50_0
			}
		}
	}
}
local var52_0 = {
	25,
	30
}
local var53_0 = {
	1,
	3,
	4,
	5,
	6
}
local var54_0 = {
	"actA",
	"actB"
}
local var55_0 = {
	10,
	15
}

local function var56_0(arg0_1, arg1_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2._sceneTf = arg0_1
			arg0_2._boatTf = findTF(arg0_1, "boat")
			arg0_2._event = arg1_1
			arg0_2._hookTf = findTF(arg0_2._boatTf, "body/hook")
			arg0_2._hookContent = findTF(arg0_2._hookTf, "container/content")
			arg0_2._hookCollider = findTF(arg0_2._hookTf, "container/collider")
			arg0_2._sceneContent = findTF(arg0_2._sceneTf, "container/content")
			arg0_2.hookAnimator = GetComponent(findTF(arg0_2._hookTf, "bottom"), typeof(Animator))
			arg0_2.hookMaskAnimator = GetComponent(findTF(arg0_2._hookTf, "mask/img"), typeof(Animator))
			arg0_2.captainAnimator = GetComponent(findTF(arg0_2._boatTf, "body/captain/img"), typeof(Animator))

			GetComponent(findTF(arg0_2._boatTf, "body/captain/img"), typeof(DftAniEvent)):SetEndEvent(function()
				if arg0_2.inGoodAct then
					arg0_2.inGoodAct = false
				end
			end)

			arg0_2.marinerAnimator = GetComponent(findTF(arg0_2._boatTf, "body/mariner/img"), typeof(Animator))
		end,
		start = function(arg0_4)
			arg0_4._hookTf.sizeDelta = Vector2(0, 1)
			arg0_4.boatState = var11_0
			arg0_4.hookRotation = var41_0
			arg0_4.hookRotationSpeed = 0
			arg0_4.hookTargetRotation = var41_0
			arg0_4.throwHook = false
			arg0_4.inGoodAct = false

			if arg0_4.catchItem then
				destroy(arg0_4.catchItem.tf)

				arg0_4.catchItem = nil
			end

			arg0_4.marinerActTime = nil
			arg0_4.marinerActName = nil

			arg0_4:leaveItem()
		end,
		step = function(arg0_5)
			if arg0_5.boatState == var11_0 then
				arg0_5:checkChangeRotation()

				arg0_5.hookRotation = arg0_5.hookRotation + arg0_5:getSpringRotation()
				arg0_5._hookTf.localEulerAngles = Vector3(0, 0, arg0_5.hookRotation)
			elseif arg0_5.boatState == var12_0 then
				if arg0_5.throwHook then
					arg0_5._hookTf.sizeDelta = Vector2(0, arg0_5._hookTf.sizeDelta.y + var39_0 * Time.deltaTime)

					local var0_5 = math.cos(math.deg2Rad * math.abs(arg0_5.hookRotation))

					if arg0_5._hookTf.sizeDelta.y * var0_5 > var38_0 or arg0_5._hookTf.sizeDelta.y > var37_0 then
						arg0_5.throwHook = false
					end
				else
					local var1_5 = arg0_5:hookBack()

					if not arg0_5.catchItem and var1_5 then
						arg0_5.boatState = var11_0
					elseif arg0_5.catchItem then
						local var2_5 = arg0_5._hookContent.position
						local var3_5 = arg0_5._sceneContent:InverseTransformPoint(var2_5)

						if (arg0_5.catchItem.data.catch == var17_0 or arg0_5.catchItem.data.act == var15_0) and var3_5.y > var45_0 then
							arg0_5.boatState = var13_0

							arg0_5:leaveItem()
						elseif var1_5 then
							arg0_5.boatState = var13_0

							arg0_5:leaveItem()
						end
					end
				end
			elseif arg0_5.boatState == var13_0 then
				if not arg0_5:hookBack() then
					return
				end

				if arg0_5.inGoodAct then
					return
				end

				arg0_5.boatState = var11_0
			end

			if arg0_5.boatState == var12_0 and arg0_5.throwHook then
				arg0_5.hookAnimator:SetBool("hook", true)
				arg0_5.hookMaskAnimator:SetBool("hook", true)
			else
				arg0_5.hookAnimator:SetBool("hook", false)
				arg0_5.hookMaskAnimator:SetBool("hook", false)
			end

			if arg0_5.boatState == var12_0 then
				if arg0_5.throwHook then
					arg0_5.captainAnimator:SetInteger("state", 4)
				else
					local var4_5 = 1

					if arg0_5.catchItem then
						var4_5 = arg0_5.catchItem.data.catch_speed >= 100 and 1 or arg0_5.catchItem.data.catch_speed >= 50 and arg0_5.catchItem.data.catch_speed <= 100 and 2 or 3
					end

					arg0_5.captainAnimator:SetInteger("state", var4_5)
				end
			else
				arg0_5.captainAnimator:SetInteger("state", 0)
			end

			if not arg0_5.marinerActTime then
				arg0_5.marinerActTime = math.random(var55_0[1], var55_0[2])
				arg0_5.marinerActName = var54_0[math.random(1, #var54_0)]
			elseif arg0_5.marinerActTime <= 0 then
				arg0_5.marinerAnimator:SetTrigger(arg0_5.marinerActName)

				arg0_5.marinerActTime = math.random(var55_0[1], var55_0[2])
				arg0_5.marinerActName = var54_0[math.random(1, #var54_0)]
			else
				arg0_5.marinerActTime = arg0_5.marinerActTime - Time.deltaTime
			end
		end,
		hookBack = function(arg0_6)
			if arg0_6._hookTf.sizeDelta.y > 1 then
				local var0_6 = var40_0 * Time.deltaTime

				if arg0_6.catchItem then
					var0_6 = arg0_6.catchItem.data.catch_speed * Time.deltaTime
				end

				arg0_6._hookTf.sizeDelta = Vector2(0, arg0_6._hookTf.sizeDelta.y - var0_6)

				return false
			elseif arg0_6._hookTf.sizeDelta.y < 1 then
				arg0_6._hookTf.sizeDelta = Vector2(0, 1)

				return false
			end

			return true
		end,
		leaveItem = function(arg0_7)
			if arg0_7.catchItem then
				arg0_7._event:emit(var10_0, arg0_7.catchItem, function()
					return
				end)

				arg0_7.inGoodAct = true

				if arg0_7.catchItem.data.good == var19_0 then
					arg0_7.captainAnimator:SetTrigger("happy")
					arg0_7.marinerAnimator:SetTrigger("happy")
				elseif arg0_7.catchItem.data.good == var21_0 then
					arg0_7.captainAnimator:SetTrigger("release")
				elseif arg0_7.catchItem.data.good == var20_0 then
					arg0_7.captainAnimator:SetTrigger("surprise")
					arg0_7.marinerAnimator:SetTrigger("surprise")
				elseif arg0_7.catchItem.data.good == var22_0 then
					arg0_7.inGoodAct = false
				end

				arg0_7.catchItem = nil
			end
		end,
		throw = function(arg0_9)
			if arg0_9.boatState ~= var11_0 then
				return
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_0)

			arg0_9.throwHook = true
			arg0_9.boatState = var12_0
		end,
		setCatchItem = function(arg0_10, arg1_10)
			if arg0_10.boatState == var12_0 and arg0_10.throwHook then
				arg0_10.catchItem = arg1_10
				arg0_10.throwHook = false
				arg1_10.tf.localScale = Vector3(math.sign(arg1_10.tf.localScale.x), 1, 1)

				SetParent(arg1_10.tf, arg0_10._hookContent)

				arg1_10.tf.anchoredPosition = Vector2(0, 0)

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4_0)
			end
		end,
		getSpringRotation = function(arg0_11)
			arg0_11.hookRotationSpeed = arg0_11.hookRotationSpeed + math.sign(arg0_11.hookTargetRotation) * var42_0

			if math.abs(arg0_11.hookRotationSpeed) > var43_0 then
				arg0_11.hookRotationSpeed = var43_0 * math.sign(arg0_11.hookTargetRotation)
			end

			return arg0_11.hookRotationSpeed * Time.deltaTime
		end,
		checkChangeRotation = function(arg0_12)
			if arg0_12.hookTargetRotation > 0 and arg0_12.hookRotation > arg0_12.hookTargetRotation then
				arg0_12.hookTargetRotation = -arg0_12.hookTargetRotation
			elseif arg0_12.hookTargetRotation < 0 and arg0_12.hookRotation < arg0_12.hookTargetRotation then
				arg0_12.hookTargetRotation = -arg0_12.hookTargetRotation
			end
		end,
		inCatch = function(arg0_13)
			return arg0_13.boatState == var12_0 and arg0_13.throwHook
		end,
		getHookPosition = function(arg0_14)
			return arg0_14._hookCollider.position
		end,
		gameOver = function(arg0_15)
			arg0_15.captainAnimator:SetTrigger("end")
			arg0_15.marinerAnimator:SetTrigger("end")
		end,
		destroy = function(arg0_16)
			return
		end
	}

	var0_1:ctor()

	return var0_1
end

local function var57_0(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = {
		ctor = function(arg0_18)
			arg0_18._event = arg3_17
			arg0_18._sceneTpls = findTF(arg0_17, "sceneTpls")
			arg0_18._backSceneTpls = findTF(arg1_17, "bgTpls")
			arg0_18._gameMission = arg2_17 + 1

			local var0_18 = findTF(arg0_17, "container")

			arg0_18._createBounds = {
				var0_18.sizeDelta.x,
				var0_18.sizeDelta.y
			}
			arg0_18._parentTf = findTF(var0_18, "content")
			arg0_18._backParentTf = findTF(arg1_17, "container/content")
			arg0_18.items = {}
		end,
		getParentInversePos = function(arg0_19, arg1_19)
			local var0_19 = arg1_19.tf.position
			local var1_19

			if arg1_19.data.scene then
				if arg1_19.data.scene == var23_0 then
					var1_19 = arg0_19._backParentTf:InverseTransformPoint(var0_19)
				else
					var1_19 = arg0_19._parentTf:InverseTransformPoint(var0_19)
				end
			else
				var1_19 = arg0_19._parentTf:InverseTransformPoint(var0_19)
			end

			return var1_19
		end,
		addItemDone = function(arg0_20, arg1_20, arg2_20)
			local var0_20 = arg0_20:getParentInversePos(arg1_20)

			if arg1_20.data.act == var15_0 or arg1_20.data.catch == var17_0 then
				var0_20.y = var45_0
			end

			arg1_20.tf.anchoredPosition = var0_20

			arg0_20:addItemParent(arg1_20)

			arg1_20.tf.localScale = Vector3(2.5 * math.sign(arg1_20.tf.localScale.x), 2.5, 2.5)
			arg1_20.tf.localEulerAngles = Vector3(0, 0, 0)
			arg1_20.catchAble = false
			arg1_20.targetRemove = true

			if arg1_20.data.catch == var16_0 then
				GetComponent(arg1_20.tf, typeof(DftAniEvent)):SetEndEvent(function()
					arg0_20:destroyItem(arg1_20)
				end)
				GetComponent(arg1_20.tf, typeof(Animator)):SetTrigger("catch")
			elseif arg1_20.data.catch == var17_0 then
				local var1_20 = arg1_20.data.leave_direct or 1

				arg1_20.direct = var1_20
				arg1_20.targetX = var1_20 * math.sign(arg1_20.tf.localScale.x) == -1 and arg1_20.data.move_range[2] or arg1_20.data.move_range[1]

				GetComponent(arg1_20.tf, typeof(DftAniEvent)):SetEndEvent(function()
					arg1_20.moveAble = true
				end)

				arg1_20.moveAble = false

				GetComponent(arg1_20.tf, typeof(Animator)):SetTrigger("release")
				table.insert(arg0_20.items, arg1_20)
			end
		end,
		start = function(arg0_23)
			arg0_23:clearItems()
			arg0_23:prepareItems()
			arg0_23:setItemPosition()
		end,
		clearItems = function(arg0_24)
			for iter0_24 = #arg0_24.items, 1, -1 do
				local var0_24 = table.remove(arg0_24.items, iter0_24)

				arg0_24:destroyItem(var0_24)

				local var1_24
			end

			arg0_24.items = {}
		end,
		prepareItems = function(arg0_25)
			local var0_25 = var35_0[math.random(1, #var35_0)]

			for iter0_25, iter1_25 in pairs(var0_25) do
				local var1_25 = math.random(iter1_25.amount[1], iter1_25.amount[2])
				local var2_25 = iter1_25.type
				local var3_25 = iter1_25.repeated
				local var4_25 = iter1_25.name
				local var5_25 = arg0_25:getItemsByType(var2_25, var4_25)

				for iter2_25 = 1, var1_25 do
					local var6_25

					if var3_25 then
						var6_25 = var5_25[math.random(1, #var5_25)]
					elseif #var5_25 > 0 then
						var6_25 = table.remove(var5_25, math.random(1, #var5_25))
					end

					if var6_25 then
						local var7_25 = arg0_25:createItem(var6_25)

						table.insert(arg0_25.items, var7_25)
					end
				end
			end
		end,
		getItemsByType = function(arg0_26, arg1_26, arg2_26)
			local var0_26 = {}

			for iter0_26 = 1, #var36_0 do
				if var36_0[iter0_26].type == arg1_26 then
					if arg2_26 then
						if table.contains(arg2_26, var36_0[iter0_26].name) then
							table.insert(var0_26, var36_0[iter0_26])
						end
					else
						table.insert(var0_26, var36_0[iter0_26])
					end
				end
			end

			return var0_26
		end,
		getItemDataByName = function(arg0_27, arg1_27)
			for iter0_27 = 1, #var36_0 do
				if var36_0[iter0_27].name == arg1_27 then
					return var36_0[iter0_27]
				end
			end

			return nil
		end,
		createItem = function(arg0_28, arg1_28)
			local var0_28 = {
				data = arg1_28
			}

			var0_28.tf = nil
			var0_28.targetX = nil
			var0_28.targetY = nil
			var0_28.direct = arg1_28.direct or 1
			var0_28.moveAble = true
			var0_28.catchAble = true
			var0_28.targetRemove = false
			var0_28.interaction = arg1_28.interaction and true or false
			var0_28.interactionName = nil
			var0_28.interactionTime = nil
			var0_28.animStateIndex = nil
			var0_28.nextAnimTime = nil

			arg0_28:instantiateItem(var0_28)

			return var0_28
		end,
		instantiateItem = function(arg0_29, arg1_29)
			local var0_29

			if arg1_29.data.scene == var23_0 then
				var0_29 = findTF(arg0_29._backSceneTpls, arg1_29.data.name)
			else
				var0_29 = findTF(arg0_29._sceneTpls, arg1_29.data.name)
			end

			local var1_29 = Instantiate(var0_29)

			arg1_29.tf = tf(var1_29)

			setActive(arg1_29.tf, true)
			arg0_29:addItemParent(arg1_29)
		end,
		addItemParent = function(arg0_30, arg1_30)
			if arg1_30.data.scene then
				if arg1_30.data.scene == var23_0 then
					SetParent(arg1_30.tf, arg0_30._backParentTf)
				else
					SetParent(arg1_30.tf, arg0_30._parentTf)
				end
			else
				SetParent(arg1_30.tf, arg0_30._parentTf)
			end
		end,
		setItemPosition = function(arg0_31)
			if not arg0_31.items or #arg0_31.items == 0 then
				return
			end

			local var0_31 = arg0_31:splitePositions(0, arg0_31._createBounds[1])
			local var1_31 = arg0_31:splitePositions(0, arg0_31._createBounds[2])
			local var2_31 = arg0_31:mixSplitePos(var0_31, var1_31)

			local function var3_31(arg0_32)
				if arg0_32 then
					local var0_32 = {}

					for iter0_32 = 1, #var2_31 do
						local var1_32 = iter0_32
						local var2_32 = var2_31[iter0_32]
						local var3_32 = arg0_32[1]
						local var4_32 = arg0_32[2]
						local var5_32 = arg0_32[3]
						local var6_32 = arg0_32[4]
						local var7_32 = var2_32[1][1]
						local var8_32 = var2_32[1][2]
						local var9_32 = var2_32[2][1]
						local var10_32 = var2_32[2][2]

						if var3_32 <= var7_32 and var8_32 <= var4_32 and var5_32 <= var9_32 and var10_32 <= var6_32 then
							table.insert(var0_32, var1_32)
						end
					end

					if #var0_32 > 0 then
						return table.remove(var2_31, var0_32[math.random(1, #var0_32)])
					end
				end

				if #var2_31 > 0 then
					return table.remove(var2_31, math.random(1, #var2_31))
				else
					return {
						{
							0,
							1300
						},
						{
							100,
							300
						}
					}
				end
			end

			for iter0_31 = 1, #arg0_31.items do
				local var4_31 = var3_31(arg0_31.items[iter0_31].data.create_range)

				if var4_31 then
					local var5_31 = var4_31[1][1] + math.random() * (var4_31[1][2] - var4_31[1][1]) / 2
					local var6_31 = var4_31[2][1] + math.random() * (var4_31[2][2] - var4_31[2][1]) / 2

					arg0_31.items[iter0_31].tf.anchoredPosition = Vector2(var5_31, var6_31)
				end
			end
		end,
		mixSplitePos = function(arg0_33, arg1_33, arg2_33)
			local var0_33 = {}

			for iter0_33 = 1, #arg1_33 do
				local var1_33 = arg1_33[iter0_33]

				for iter1_33 = 1, #arg2_33 do
					local var2_33 = arg2_33[iter1_33]

					table.insert(var0_33, {
						var1_33,
						var2_33
					})
				end
			end

			return var0_33
		end,
		splitePositions = function(arg0_34, arg1_34, arg2_34)
			local var0_34 = {}

			if not arg1_34 or not arg2_34 or arg2_34 < arg1_34 then
				return nil
			end

			local var1_34 = (arg2_34 - arg1_34) / var46_0

			for iter0_34 = 1, var1_34 do
				table.insert(var0_34, {
					arg1_34 + (iter0_34 - 1) * var46_0,
					arg1_34 + iter0_34 * var46_0
				})
			end

			return var0_34
		end,
		getItemByPos = function(arg0_35, arg1_35)
			local var0_35 = arg0_35:checkPosInCollider(arg1_35)

			if var0_35 then
				if var0_35.data.catch_rule then
					local var1_35 = GetComponent(var0_35.tf, typeof(Animator)):GetInteger("state")
					local var2_35 = var0_35.data.catch_rule.state

					if table.contains(var2_35, var1_35) then
						arg0_35:addItemDone(var0_35)

						return (arg0_35:createItem(arg0_35:getItemDataByName(var0_35.data.catch_rule.targetName)))
					end
				else
					return var0_35
				end

				return var0_35
			end

			return nil
		end,
		checkPosInCollider = function(arg0_36, arg1_36)
			local var0_36 = {}
			local var1_36 = arg0_36._parentTf:InverseTransformPoint(arg1_36.x, arg1_36.y, arg1_36.z)

			for iter0_36 = 1, #arg0_36.items do
				if arg0_36.items[iter0_36].data.catch ~= var18_0 then
					local var2_36 = arg0_36.items[iter0_36].tf

					if math.abs(var1_36.x - var2_36.anchoredPosition.x) < var44_0 and math.abs(var1_36.y - var2_36.anchoredPosition.y) < var44_0 and arg0_36.items[iter0_36].data.catch ~= var18_0 and arg0_36.items[iter0_36].catchAble then
						table.insert(var0_36, arg0_36.items[iter0_36])
					end
				end
			end

			for iter1_36 = 1, #var0_36 do
				local var3_36 = findTF(var0_36[iter1_36].tf, "collider")

				if not var3_36 then
					print("can not find collider by" .. var0_36[iter1_36].data.name)
				else
					local var4_36 = var3_36:InverseTransformPoint(arg1_36.x, arg1_36.y, arg1_36.z)
					local var5_36 = var3_36.rect.xMin
					local var6_36 = var3_36.rect.yMin
					local var7_36 = var3_36.rect.width
					local var8_36 = var3_36.rect.height

					if arg0_36:isPointInMatrix(Vector2(var5_36, var6_36 + var8_36), Vector2(var5_36 + var7_36, var6_36 + var8_36), Vector2(var5_36 + var7_36, var6_36), Vector2(var5_36, var6_36), var4_36) then
						return arg0_36:removeItem(var0_36[iter1_36])
					end
				end
			end

			return nil
		end,
		removeItem = function(arg0_37, arg1_37)
			for iter0_37 = 1, #arg0_37.items do
				if arg0_37.items[iter0_37] == arg1_37 then
					return table.remove(arg0_37.items, iter0_37)
				end
			end
		end,
		getCross = function(arg0_38, arg1_38, arg2_38, arg3_38)
			return (arg2_38.x - arg1_38.x) * (arg3_38.y - arg1_38.y) - (arg3_38.x - arg1_38.x) * (arg2_38.y - arg1_38.y)
		end,
		isPointInMatrix = function(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39, arg5_39)
			return arg0_39:getCross(arg1_39, arg2_39, arg5_39) * arg0_39:getCross(arg3_39, arg4_39, arg5_39) >= 0 and arg0_39:getCross(arg2_39, arg3_39, arg5_39) * arg0_39:getCross(arg4_39, arg1_39, arg5_39) >= 0
		end,
		step = function(arg0_40)
			for iter0_40 = #arg0_40.items, 1, -1 do
				local var0_40 = arg0_40.items[iter0_40]

				if var0_40.data.act == var15_0 and var0_40.moveAble then
					if not var0_40.targetX then
						local var1_40 = var0_40.data.move_range[1]
						local var2_40 = var0_40.data.move_range[2]

						if var0_40.tf.anchoredPosition.x == var1_40 then
							var0_40.targetX = var2_40
						elseif var0_40.tf.anchoredPosition.x == var2_40 then
							var0_40.targetX = var1_40
						else
							var0_40.targetX = math.random() > 0.5 and var1_40 or var2_40
						end
					else
						local var3_40 = math.sign(var0_40.targetX - var0_40.tf.anchoredPosition.x)
						local var4_40 = var0_40.targetRemove and var0_40.data.release_speed or var0_40.data.speed

						var0_40.tf.localScale = Vector3(-1 * var3_40 * var0_40.direct * math.abs(var0_40.tf.localScale.x), var0_40.tf.localScale.y, var0_40.tf.localScale.z)

						local var5_40 = var3_40 * var4_40 * Time.deltaTime

						var0_40.tf.anchoredPosition = Vector2(var0_40.tf.anchoredPosition.x + var5_40, var0_40.tf.anchoredPosition.y)

						if var3_40 == 1 and var0_40.tf.anchoredPosition.x >= var0_40.targetX or var3_40 == -1 and var0_40.tf.anchoredPosition.x <= var0_40.targetX then
							var0_40.tf.anchoredPosition = Vector2(var0_40.targetX, var0_40.tf.anchoredPosition.y)
							var0_40.targetX = nil
						end
					end
				end

				if var0_40.data.anim_data then
					local var6_40 = var0_40.data.anim_data.state_change
					local var7_40 = var0_40.data.anim_data.time

					if var6_40 and var7_40 then
						if not var0_40.nextAnimTime then
							var0_40.nextAnimTime = math.random(var7_40[1], var7_40[2])
							var0_40.animStateIndex = 1
						elseif var0_40.nextAnimTime <= 0 then
							GetComponent(var0_40.tf, typeof(Animator)):SetInteger("state", var6_40[var0_40.animStateIndex])

							var0_40.nextAnimTime = math.random(var7_40[1], var7_40[2])
							var0_40.animStateIndex = var0_40.animStateIndex + 1
							var0_40.animStateIndex = var0_40.animStateIndex > #var6_40 and 1 or var0_40.animStateIndex
						else
							var0_40.nextAnimTime = var0_40.nextAnimTime - Time.deltaTime
						end
					end
				end

				if var0_40.interaction and not var0_40.targetRemove then
					if not var0_40.interactionTime then
						var0_40.interactionTime = math.random() * (var0_40.data.interaction.time[2] - var0_40.data.interaction.time[1]) + var0_40.data.interaction.time[1]
						var0_40.interactionName = var0_40.data.interaction.parame[math.random(1, #var0_40.data.interaction.parame)]
					elseif var0_40.interactionTime <= 0 then
						GetComponent(var0_40.tf, typeof(Animator)):SetTrigger(var0_40.interactionName)

						var0_40.interactionTime = nil
						var0_40.interactionName = nil
					else
						var0_40.interactionTime = var0_40.interactionTime - Time.deltaTime
					end
				end

				if var0_40.targetRemove and not var0_40.targetX then
					table.remove(arg0_40.items, iter0_40)
					arg0_40:destroyItem(var0_40)
				end
			end
		end,
		destroyItem = function(arg0_41, arg1_41)
			destroy(arg1_41.tf)
		end,
		destroy = function(arg0_42)
			return
		end
	}

	var0_17:ctor()

	return var0_17
end

local function var58_0(arg0_43, arg1_43)
	local var0_43 = {
		ctor = function(arg0_44)
			arg0_44._boatController = arg0_43
			arg0_44._itemController = arg1_43
		end,
		start = function(arg0_45)
			return
		end,
		step = function(arg0_46)
			if arg0_46._boatController:inCatch() then
				local var0_46 = arg0_46._boatController:getHookPosition()
				local var1_46 = arg0_46._itemController:getItemByPos(var0_46)

				if var1_46 then
					GetComponent(var1_46.tf, typeof(Animator)):SetTrigger("hold")
					arg0_46._boatController:setCatchItem(var1_46)
				end
			end
		end,
		destroy = function(arg0_47)
			return
		end
	}

	var0_43:ctor()

	return var0_43
end

local function var59_0(arg0_48, arg1_48)
	local var0_48 = {
		ctor = function(arg0_49)
			arg0_49._charTpls = findTF(arg0_48, "charTpls")
			arg0_49._content = findTF(arg0_48, "charContainer/content")
			arg0_49._event = arg1_48
		end,
		start = function(arg0_50)
			arg0_50:clear()

			arg0_50.chars = {}
			arg0_50.nextTime = math.random(var52_0[1], var52_0[2])
			arg0_50.showChars = Clone(var53_0)
		end,
		step = function(arg0_51)
			if arg0_51.nextTime <= 0 and #arg0_51.showChars > 0 then
				table.insert(arg0_51.chars, arg0_51:createChar())

				arg0_51.nextTime = math.random(var52_0[1], var52_0[2])
			else
				arg0_51.nextTime = arg0_51.nextTime - Time.deltaTime
			end

			arg0_51:setCharAction()

			for iter0_51 = #arg0_51.chars, 1, -1 do
				arg0_51:stepChar(arg0_51.chars[iter0_51])

				if arg0_51.chars[iter0_51].removeFlag then
					arg0_51:removeChar(table.remove(arg0_51.chars, iter0_51))
				end
			end
		end,
		stepChar = function(arg0_52, arg1_52)
			local var0_52 = false

			if arg1_52.posX then
				arg1_52.tf.anchoredPosition = Vector2(arg1_52.posX + (arg1_52.offsetX or 0), 0)

				setActive(arg1_52.tf, true)

				arg1_52.posX = nil
				arg1_52.offsetX = nil
			end

			if arg1_52.moveToX then
				local var1_52 = arg1_52.moveToX + arg1_52.offsetX
				local var2_52 = arg1_52.tf.anchoredPosition
				local var3_52 = math.sign(var1_52 - var2_52.x)

				arg1_52.tf.anchoredPosition = Vector3(var2_52.x + var3_52 * arg1_52.speed, 0)

				local var4_52 = math.sign(var2_52.x - var1_52)
				local var5_52 = math.sign(arg1_52.tf.anchoredPosition.x - var1_52)

				if arg1_52.tf.anchoredPosition.x == var1_52 or var4_52 ~= var5_52 then
					arg1_52.moveToX = nil
					arg1_52.offsetX = nil
				else
					var0_52 = true
				end
			end

			if arg1_52.triggerName or arg1_52.time then
				if arg1_52.triggerName and arg1_52.animator then
					arg1_52.animator:SetTrigger(arg1_52.triggerName)

					arg1_52.triggerName = nil
				end

				arg1_52.time = arg1_52.time - Time.deltaTime

				if arg1_52.triggerName == nil and arg1_52.time <= 0 then
					arg1_52.time = nil
				else
					var0_52 = true
				end
			end

			arg1_52.inAction = var0_52
		end,
		getRandomMoveX = function(arg0_53, arg1_53, arg2_53)
			return arg1_53 + math.random(0, arg2_53 - arg1_53)
		end,
		removeChar = function(arg0_54, arg1_54)
			if arg1_54.bindChars then
				arg1_54.bindChars = {}
			end

			destroy(arg1_54.tf)
		end,
		setCharAction = function(arg0_55)
			for iter0_55 = 1, #arg0_55.chars do
				local var0_55 = arg0_55.chars[iter0_55]

				if not var0_55.currentActionInfo and #var0_55.actionInfos > 0 and not var0_55.inAction then
					if var0_55.sync and var0_55.bindIds and #var0_55.bindIds > 0 then
						local var1_55 = true

						for iter1_55, iter2_55 in ipairs(var0_55.bindChars) do
							if iter2_55.inAction or not iter2_55.sync then
								var1_55 = false
							end
						end

						if var1_55 then
							var0_55.currentActionInfo = table.remove(var0_55.actionInfos, 1)

							for iter3_55, iter4_55 in ipairs(var0_55.bindChars) do
								iter4_55.sync = false
							end
						end
					elseif not var0_55.sync then
						var0_55.currentActionInfo = table.remove(var0_55.actionInfos, 1)
					end
				end

				if var0_55.currentActionInfo and not var0_55.currentActionInfo.sync then
					arg0_55:addCharAction(var0_55)
				elseif var0_55.currentActionInfo and var0_55.currentActionInfo.sync and var0_55.bindIds then
					arg0_55:addCharAction(var0_55)

					for iter5_55, iter6_55 in ipairs(var0_55.bindChars) do
						if iter6_55 and iter6_55.currentActionInfo and iter6_55.currentActionInfo.sync then
							arg0_55:addBindCharAction(var0_55, iter6_55)
						end
					end
				elseif not var0_55.currentActionInfo and #var0_55.actionInfos == 0 and not var0_55.inAction then
					var0_55.removeFlag = true
				end
			end
		end,
		addBindCharAction = function(arg0_56, arg1_56, arg2_56)
			if arg2_56.currentActionInfo.type == var49_0 then
				arg2_56.moveToX = arg1_56.moveToX
				arg2_56.offsetX = arg2_56.currentActionInfo.offsetX or 0
			elseif arg2_56.currentActionInfo.type == var48_0 then
				-- block empty
			elseif arg2_56.currentActionInfo.type == var50_0 then
				-- block empty
			end

			arg2_56.sync = arg2_56.currentActionInfo.sync
			arg2_56.currentActionInfo = nil
			arg2_56.inAction = true
		end,
		addCharAction = function(arg0_57, arg1_57)
			local var0_57 = arg1_57.currentActionInfo.type

			if var0_57 == var49_0 then
				local var1_57

				if arg1_57.currentActionInfo.moveToX then
					var1_57 = arg0_57:getRandomMoveX(arg1_57.currentActionInfo.moveToX[1], arg1_57.currentActionInfo.moveToX[2])
				end

				arg1_57.moveToX = var1_57 or 0
				arg1_57.offsetX = arg1_57.currentActionInfo.offsetX or 0
			elseif var0_57 == var48_0 then
				arg1_57.posX = arg1_57.currentActionInfo.posX or 0
				arg1_57.offsetX = arg1_57.currentActionInfo.offsetX or 0
			elseif var0_57 == var50_0 then
				arg1_57.triggerName = arg1_57.currentActionInfo.trigger
				arg1_57.time = arg1_57.currentActionInfo.time or 0
			end

			arg1_57.sync = arg1_57.currentActionInfo.sync
			arg1_57.inAction = true
			arg1_57.currentActionInfo = nil
		end,
		createChar = function(arg0_58, arg1_58)
			local var0_58 = {}
			local var1_58 = Clone(arg1_58) or arg0_58:getRandomData()

			if not var1_58 then
				return
			end

			var0_58.data = var1_58
			var0_58.id = var1_58.id
			var0_58.bindIds = var1_58.bindIds
			var0_58.bindChars = {}
			var0_58.actionInfos = var1_58.actions
			var0_58.speed = var1_58.speed
			var0_58.tf = arg0_58:getCharTf(var1_58.tf)
			var0_58.animator = GetComponent(findTF(var0_58.tf, "anim"), typeof(Animator))
			var0_58.dft = GetComponent(findTF(var0_58.tf, "anim"), typeof(DftAniEvent))
			var0_58.currentActionInfo = nil
			var0_58.posX = nil
			var0_58.moveToX = nil
			var0_58.offsetX = nil
			var0_58.triggerName = nil
			var0_58.time = nil
			var0_58.inAction = false
			var0_58.removeFlag = false

			if var0_58.bindIds then
				for iter0_58 = 1, #var0_58.bindIds do
					local var2_58 = arg0_58:createChar(arg0_58:getCharDataById(var0_58.bindIds[iter0_58]))

					table.insert(arg0_58.chars, var2_58)
					table.insert(var0_58.bindChars, var2_58)
				end
			end

			return var0_58
		end,
		getRandomData = function(arg0_59)
			if arg0_59.showChars and #arg0_59.showChars > 0 then
				local var0_59 = table.remove(arg0_59.showChars, math.random(1, #arg0_59.showChars))

				return arg0_59:getCharDataById(var0_59)
			end

			return nil
		end,
		getCharDataById = function(arg0_60, arg1_60)
			for iter0_60, iter1_60 in ipairs(var51_0) do
				if iter1_60.id == arg1_60 then
					return Clone(iter1_60)
				end
			end
		end,
		getCharTf = function(arg0_61, arg1_61)
			local var0_61 = tf(instantiate(findTF(arg0_61._charTpls, arg1_61)))

			SetParent(var0_61, arg0_61._content)
			SetActive(var0_61, false)

			return var0_61
		end,
		clear = function(arg0_62)
			if arg0_62.chars then
				for iter0_62 = #arg0_62.chars, 1, -1 do
					arg0_62:removeChar(table.remove(arg0_62.chars, iter0_62))
				end

				arg0_62.chars = {}
			end
		end
	}

	var0_48:ctor()

	return var0_48
end

function var0_0.getUIName(arg0_63)
	return "CatchTreasureGameUI"
end

function var0_0.getBGM(arg0_64)
	return var1_0
end

function var0_0.didEnter(arg0_65)
	arg0_65:initEvent()
	arg0_65:initData()
	arg0_65:initUI()
	arg0_65:initGameUI()
	arg0_65:updateMenuUI()
	arg0_65:openMenuUI()
end

function var0_0.initEvent(arg0_66)
	arg0_66:bind(var10_0, function(arg0_67, arg1_67, arg2_67)
		if arg0_66.itemController then
			arg0_66.itemController:addItemDone(arg1_67, arg2_67)
		end

		arg0_66:addScore(arg1_67.data.score, arg1_67.data.time)
	end)
end

function var0_0.initData(arg0_68)
	arg0_68.dropData = pg.mini_game[arg0_68:GetMGData().id].simple_config_data.drop

	local var0_68 = Application.targetFrameRate or 60

	if var0_68 > 60 then
		var0_68 = 60
	end

	arg0_68.timer = Timer.New(function()
		arg0_68:onTimer()
	end, 1 / var0_68, -1)
end

function var0_0.initUI(arg0_70)
	arg0_70.backSceneTf = findTF(arg0_70._tf, "scene_container/scene_background")
	arg0_70.sceneTf = findTF(arg0_70._tf, "scene_container/scene")
	arg0_70.bgTf = findTF(arg0_70._tf, "bg")
	arg0_70.clickMask = findTF(arg0_70._tf, "clickMask")
	arg0_70.countUI = findTF(arg0_70._tf, "pop/CountUI")
	arg0_70.countAnimator = GetComponent(findTF(arg0_70.countUI, "count"), typeof(Animator))
	arg0_70.countDft = GetOrAddComponent(findTF(arg0_70.countUI, "count"), typeof(DftAniEvent))

	arg0_70.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_70.countDft:SetEndEvent(function()
		setActive(arg0_70.countUI, false)
		arg0_70:gameStart()
	end)
	SetActive(arg0_70.countUI, false)

	arg0_70.leaveUI = findTF(arg0_70._tf, "pop/LeaveUI")

	onButton(arg0_70, findTF(arg0_70.leaveUI, "ad/btnOk"), function()
		arg0_70:resumeGame()
		arg0_70:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_70, findTF(arg0_70.leaveUI, "ad/btnCancel"), function()
		arg0_70:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0_70.leaveUI, false)

	arg0_70.pauseUI = findTF(arg0_70._tf, "pop/pauseUI")

	onButton(arg0_70, findTF(arg0_70.pauseUI, "ad/btnOk"), function()
		setActive(arg0_70.pauseUI, false)
		arg0_70:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0_70.pauseUI, false)

	arg0_70.settlementUI = findTF(arg0_70._tf, "pop/SettleMentUI")

	onButton(arg0_70, findTF(arg0_70.settlementUI, "ad/btnOver"), function()
		setActive(arg0_70.settlementUI, false)
		arg0_70:openMenuUI()
	end, SFX_CANCEL)
	SetActive(arg0_70.settlementUI, false)

	arg0_70.menuUI = findTF(arg0_70._tf, "pop/menuUI")
	arg0_70.battleScrollRect = GetComponent(findTF(arg0_70.menuUI, "battList"), typeof(ScrollRect))
	arg0_70.titleDesc = findTF(arg0_70.menuUI, "desc")

	GetComponent(arg0_70.titleDesc, typeof(Image)):SetNativeSize()

	arg0_70.totalTimes = arg0_70:getGameTotalTime()

	local var0_70 = arg0_70:getGameUsedTimes() - 4 < 0 and 0 or arg0_70:getGameUsedTimes() - 4

	scrollTo(arg0_70.battleScrollRect, 0, 1 - var0_70 / (arg0_70.totalTimes - 4))
	onButton(arg0_70, findTF(arg0_70.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_77 = arg0_70.battleScrollRect.normalizedPosition.y + 1 / (arg0_70.totalTimes - 4)

		if var0_77 > 1 then
			var0_77 = 1
		end

		scrollTo(arg0_70.battleScrollRect, 0, var0_77)
	end, SFX_CANCEL)
	onButton(arg0_70, findTF(arg0_70.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_78 = arg0_70.battleScrollRect.normalizedPosition.y - 1 / (arg0_70.totalTimes - 4)

		if var0_78 < 0 then
			var0_78 = 0
		end

		scrollTo(arg0_70.battleScrollRect, 0, var0_78)
	end, SFX_CANCEL)
	onButton(arg0_70, findTF(arg0_70.menuUI, "btnBack"), function()
		arg0_70:closeView()
	end, SFX_CANCEL)
	onButton(arg0_70, findTF(arg0_70.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var9_0].tip
		})
	end, SFX_CANCEL)
	onButton(arg0_70, findTF(arg0_70.menuUI, "btnStart"), function()
		setActive(arg0_70.menuUI, false)
		arg0_70:readyStart()
	end, SFX_CANCEL)

	local var1_70 = findTF(arg0_70.menuUI, "tplBattleItem")

	arg0_70.battleItems = {}
	arg0_70.dropItems = {}

	for iter0_70 = 1, 7 do
		local var2_70 = tf(instantiate(var1_70))

		var2_70.name = "battleItem_" .. iter0_70

		setParent(var2_70, findTF(arg0_70.menuUI, "battList/Viewport/Content"))

		local var3_70 = iter0_70

		GetSpriteFromAtlasAsync(var8_0, "buttomDesc" .. var3_70, function(arg0_82)
			setImageSprite(findTF(var2_70, "state_open/buttomDesc"), arg0_82, true)
			setImageSprite(findTF(var2_70, "state_clear/buttomDesc"), arg0_82, true)
			setImageSprite(findTF(var2_70, "state_current/buttomDesc"), arg0_82, true)
			setImageSprite(findTF(var2_70, "state_closed/buttomDesc"), arg0_82, true)
		end)

		local var4_70 = findTF(var2_70, "icon")
		local var5_70 = {
			type = arg0_70.dropData[iter0_70][1],
			id = arg0_70.dropData[iter0_70][2],
			count = arg0_70.dropData[iter0_70][3]
		}

		updateDrop(var4_70, var5_70)
		onButton(arg0_70, var4_70, function()
			arg0_70:emit(BaseUI.ON_DROP, var5_70)
		end, SFX_PANEL)
		table.insert(arg0_70.dropItems, var4_70)
		setActive(var2_70, true)
		table.insert(arg0_70.battleItems, var2_70)
	end

	if not arg0_70.handle then
		arg0_70.handle = UpdateBeat:CreateListener(arg0_70.Update, arg0_70)
	end

	UpdateBeat:AddListener(arg0_70.handle)
end

function var0_0.initGameUI(arg0_84)
	arg0_84.gameUI = findTF(arg0_84._tf, "ui/gameUI")

	onButton(arg0_84, findTF(arg0_84.gameUI, "topRight/btnStop"), function()
		arg0_84:stopGame()
		setActive(arg0_84.pauseUI, true)
	end)
	onButton(arg0_84, findTF(arg0_84.gameUI, "btnLeave"), function()
		arg0_84:stopGame()
		setActive(arg0_84.leaveUI, true)
	end)

	arg0_84.dragDelegate = GetOrAddComponent(arg0_84.sceneTf, "EventTriggerListener")
	arg0_84.dragDelegate.enabled = true

	arg0_84.dragDelegate:AddPointDownFunc(function(arg0_87, arg1_87)
		if arg0_84.boatController then
			arg0_84.boatController:throw()
		end
	end)

	arg0_84.gameTimeS = findTF(arg0_84.gameUI, "top/time/s")
	arg0_84.scoreTf = findTF(arg0_84.gameUI, "top/score")
	arg0_84.boatController = var56_0(arg0_84.sceneTf, arg0_84)
	arg0_84.itemController = var57_0(arg0_84.sceneTf, arg0_84.backSceneTf, arg0_84:getGameUsedTimes(), arg0_84)
	arg0_84.catchController = var58_0(arg0_84.boatController, arg0_84.itemController)
	arg0_84.charController = var59_0(arg0_84.backSceneTf, arg0_84)
	arg0_84.sceneScoreTf = findTF(arg0_84.sceneTf, "scoreTf")

	setActive(arg0_84.sceneScoreTf, false)
end

function var0_0.Update(arg0_88)
	arg0_88:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_89)
	if arg0_89.gameStop or arg0_89.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0_0.updateMenuUI(arg0_90)
	local var0_90 = arg0_90:getGameUsedTimes()
	local var1_90 = arg0_90:getGameTimes()

	for iter0_90 = 1, #arg0_90.battleItems do
		setActive(findTF(arg0_90.battleItems[iter0_90], "state_open"), false)
		setActive(findTF(arg0_90.battleItems[iter0_90], "state_closed"), false)
		setActive(findTF(arg0_90.battleItems[iter0_90], "state_clear"), false)
		setActive(findTF(arg0_90.battleItems[iter0_90], "state_current"), false)

		if iter0_90 <= var0_90 then
			setActive(findTF(arg0_90.battleItems[iter0_90], "state_clear"), true)
			SetParent(arg0_90.dropItems[iter0_90], findTF(arg0_90.battleItems[iter0_90], "state_clear/icon"))
			setActive(arg0_90.dropItems[iter0_90], true)

			arg0_90.dropItems[iter0_90].anchoredPosition = Vector2(0, 0)
		elseif iter0_90 == var0_90 + 1 and var1_90 >= 1 then
			setActive(findTF(arg0_90.battleItems[iter0_90], "state_current"), true)
			SetParent(arg0_90.dropItems[iter0_90], findTF(arg0_90.battleItems[iter0_90], "state_current/icon"))
			setActive(arg0_90.dropItems[iter0_90], true)

			arg0_90.dropItems[iter0_90].anchoredPosition = Vector2(0, 0)
		elseif var0_90 < iter0_90 and iter0_90 <= var0_90 + var1_90 then
			setActive(findTF(arg0_90.battleItems[iter0_90], "state_open"), true)
			SetParent(arg0_90.dropItems[iter0_90], findTF(arg0_90.battleItems[iter0_90], "state_open/icon"))
			setActive(arg0_90.dropItems[iter0_90], true)

			arg0_90.dropItems[iter0_90].anchoredPosition = Vector2(0, 0)
		else
			setActive(findTF(arg0_90.battleItems[iter0_90], "state_closed"), true)
			setActive(arg0_90.dropItems[iter0_90], false)
		end
	end

	arg0_90.totalTimes = arg0_90:getGameTotalTime()

	local var2_90 = 1 - (arg0_90:getGameUsedTimes() - 3 < 0 and 0 or arg0_90:getGameUsedTimes() - 3) / (arg0_90.totalTimes - 4)

	if var2_90 > 1 then
		var2_90 = 1
	end

	scrollTo(arg0_90.battleScrollRect, 0, var2_90)
	setActive(findTF(arg0_90.menuUI, "btnStart/tip"), var1_90 > 0)
	arg0_90:CheckGet()
end

function var0_0.CheckGet(arg0_91)
	setActive(findTF(arg0_91.menuUI, "got"), false)

	if arg0_91:getUltimate() and arg0_91:getUltimate() ~= 0 then
		setActive(findTF(arg0_91.menuUI, "got"), true)
	end

	if arg0_91:getUltimate() == 0 then
		if arg0_91:getGameTotalTime() > arg0_91:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_91:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_91.menuUI, "got"), true)
	end
end

function var0_0.openMenuUI(arg0_92)
	setActive(findTF(arg0_92._tf, "scene_container"), false)
	setActive(findTF(arg0_92.bgTf, "on"), true)
	setActive(arg0_92.gameUI, false)
	setActive(arg0_92.menuUI, true)
	arg0_92:updateMenuUI()
end

function var0_0.clearUI(arg0_93)
	setActive(arg0_93.sceneTf, false)
	setActive(arg0_93.settlementUI, false)
	setActive(arg0_93.countUI, false)
	setActive(arg0_93.menuUI, false)
	setActive(arg0_93.gameUI, false)
end

function var0_0.readyStart(arg0_94)
	setActive(arg0_94.countUI, true)
	arg0_94.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)
end

function var0_0.getGameTimes(arg0_95)
	return arg0_95:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_96)
	return arg0_96:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_97)
	return arg0_97:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_98)
	return (arg0_98:GetMGHubData():getConfig("reward_need"))
end

function var0_0.gameStart(arg0_99)
	setActive(findTF(arg0_99._tf, "scene_container"), true)
	setActive(findTF(arg0_99.bgTf, "on"), false)
	setActive(arg0_99.gameUI, true)

	arg0_99.gameStartFlag = true
	arg0_99.scoreNum = 0
	arg0_99.playerPosIndex = 2
	arg0_99.gameStepTime = 0
	arg0_99.heart = 3
	arg0_99.gameTime = var7_0

	SetActive(arg0_99.sceneScoreTf, false)

	if arg0_99.boatController then
		arg0_99.boatController:start()
	end

	if arg0_99.itemController then
		arg0_99.itemController:start()
	end

	if arg0_99.catchController then
		arg0_99.catchController:start()
	end

	if arg0_99.charController then
		arg0_99.charController:start()
	end

	arg0_99:updateGameUI()
	arg0_99:timerStart()
end

function var0_0.transformColor(arg0_100, arg1_100)
	local var0_100 = tonumber(string.sub(arg1_100, 1, 2), 16)
	local var1_100 = tonumber(string.sub(arg1_100, 3, 4), 16)
	local var2_100 = tonumber(string.sub(arg1_100, 5, 6), 16)

	return Color.New(var0_100 / 255, var1_100 / 255, var2_100 / 255)
end

function var0_0.addScore(arg0_101, arg1_101, arg2_101)
	if arg1_101 and arg1_101 > 0 or arg2_101 and arg2_101 > 0 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_0)
	elseif arg1_101 and arg1_101 < 0 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var6_0)
	end

	setActive(arg0_101.sceneScoreTf, false)

	local var0_101 = findTF(arg0_101.sceneScoreTf, "img")
	local var1_101 = GetComponent(var0_101, typeof(Text))
	local var2_101 = "6f1807"

	if arg1_101 then
		local var3_101

		for iter0_101 = 1, #var47_0 do
			if arg1_101 and arg1_101 >= var47_0[iter0_101].score then
				var2_101 = var47_0[iter0_101].color
				var3_101 = var47_0[iter0_101].font

				break
			end
		end

		local var4_101 = arg0_101:transformColor(var2_101)

		arg0_101.scoreNum = arg0_101.scoreNum + arg1_101

		local var5_101 = arg1_101 >= 0 and "+" or ""

		setText(var0_101, var5_101 .. arg1_101)

		var1_101.fontSize = var3_101 or 40

		setTextColor(var0_101, var4_101)
	elseif arg2_101 then
		local var6_101 = arg0_101:transformColor("66f2fb")

		var1_101.fontSize = 40

		setTextColor(var0_101, var6_101)

		if arg0_101.gameTime > 0 then
			arg0_101.gameTime = arg0_101.gameTime + arg2_101
		end

		local var7_101 = arg2_101 > 0 and "+" or ""

		setText(var0_101, var7_101 .. arg2_101 .. "s")
	end

	setActive(arg0_101.sceneScoreTf, true)
end

function var0_0.onTimer(arg0_102)
	arg0_102:gameStep()
end

function var0_0.gameStep(arg0_103)
	arg0_103.gameTime = arg0_103.gameTime - Time.deltaTime
	arg0_103.gameStepTime = arg0_103.gameStepTime + Time.deltaTime

	if arg0_103.boatController then
		arg0_103.boatController:step()
	end

	if arg0_103.itemController then
		arg0_103.itemController:step()
	end

	if arg0_103.catchController then
		arg0_103.catchController:step()
	end

	if arg0_103.charController then
		arg0_103.charController:step()
	end

	if arg0_103.gameTime < 0 then
		arg0_103.gameTime = 0
	end

	arg0_103:updateGameUI()

	if arg0_103.gameTime <= 0 then
		arg0_103:onGameOver()

		return
	end
end

function var0_0.timerStart(arg0_104)
	if not arg0_104.timer.running then
		arg0_104.timer:Start()
	end
end

function var0_0.timerStop(arg0_105)
	if arg0_105.timer.running then
		arg0_105.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_106)
	setText(arg0_106.scoreTf, arg0_106.scoreNum)
	setText(arg0_106.gameTimeS, math.ceil(arg0_106.gameTime))
end

function var0_0.onGameOver(arg0_107)
	if arg0_107.settlementFlag then
		return
	end

	arg0_107:timerStop()

	arg0_107.settlementFlag = true

	setActive(arg0_107.clickMask, true)

	if arg0_107.boatController then
		arg0_107.boatController:gameOver()
	end

	LeanTween.delayedCall(go(arg0_107._tf), 2, System.Action(function()
		arg0_107.settlementFlag = false
		arg0_107.gameStartFlag = false

		setActive(arg0_107.clickMask, false)
		arg0_107:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_109)
	setActive(arg0_109.settlementUI, true)
	GetComponent(findTF(arg0_109.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_109 = arg0_109:GetMGData():GetRuntimeData("elements")
	local var1_109 = arg0_109.scoreNum
	local var2_109 = var0_109 and #var0_109 > 0 and var0_109[1] or 0

	setActive(findTF(arg0_109.settlementUI, "ad/new"), var2_109 < var1_109)

	if var2_109 <= var1_109 then
		var2_109 = var1_109

		arg0_109:StoreDataToServer({
			var2_109
		})
	end

	local var3_109 = findTF(arg0_109.settlementUI, "ad/highText")
	local var4_109 = findTF(arg0_109.settlementUI, "ad/currentText")

	setText(var3_109, var2_109)
	setText(var4_109, var1_109)

	if arg0_109:getGameTimes() and arg0_109:getGameTimes() > 0 then
		arg0_109.sendSuccessFlag = true

		arg0_109:SendSuccess(0)
	end
end

function var0_0.resumeGame(arg0_110)
	arg0_110.gameStop = false

	setActive(arg0_110.leaveUI, false)
	arg0_110:timerStart()
end

function var0_0.stopGame(arg0_111)
	arg0_111.gameStop = true

	arg0_111:timerStop()
end

function var0_0.onBackPressed(arg0_112)
	if not arg0_112.gameStartFlag then
		arg0_112:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_112.settlementFlag then
			return
		end

		if isActive(arg0_112.pauseUI) then
			setActive(arg0_112.pauseUI, false)
		end

		arg0_112:stopGame()
		setActive(arg0_112.leaveUI, true)
	end
end

function var0_0.willExit(arg0_113)
	if arg0_113.handle then
		UpdateBeat:RemoveListener(arg0_113.handle)
	end

	if arg0_113._tf and LeanTween.isTweening(go(arg0_113._tf)) then
		LeanTween.cancel(go(arg0_113._tf))
	end

	if arg0_113.timer and arg0_113.timer.running then
		arg0_113.timer:Stop()
	end

	Time.timeScale = 1
	arg0_113.timer = nil
end

return var0_0
