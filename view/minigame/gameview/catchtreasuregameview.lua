local var0 = class("CatchTreasureGameView", import("..BaseMiniGameView"))
local var1 = "blueocean-image"
local var2 = "event:/ui/ddldaoshu2"
local var3 = "event:/ui/taosheng"
local var4 = "event:/ui/zhuahuo"
local var5 = "event:/ui/deshou"
local var6 = "event:/ui/shibai"
local var7 = 60
local var8 = "ui/catchtreasuregameui_atlas"
local var9 = "salvage_tips"
local var10 = "event item done"
local var11 = "boat state stand"
local var12 = "boat state thorw"
local var13 = "boat state wait"
local var14 = "item act static"
local var15 = "item act dynamic"
local var16 = "item catch normal"
local var17 = "item catch release"
local var18 = "item catch unable"
local var19 = "item good happy"
local var20 = "item good surprise"
local var21 = "item good release"
local var22 = "item good none"
local var23 = "item scene back"
local var24 = "item scene middle"
local var25 = "item scene front"
local var26 = "item type fish"
local var27 = "item type submarine"
local var28 = "item type goods"
local var29 = "item type sundries"
local var30 = "item type time"
local var31 = "item type back"
local var32 = "item type bind"
local var33 = "item type name "
local var34 = {
	{
		type = var14,
		range = {
			5,
			8
		}
	},
	{
		type = var15,
		range = {
			5,
			8
		}
	}
}
local var35 = {
	{
		{
			repeated = true,
			type = var31,
			amount = {
				8,
				10
			}
		},
		{
			repeated = true,
			type = var28,
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
			type = var28,
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
			type = var28,
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
			type = var29,
			amount = {
				3,
				3
			}
		},
		{
			repeated = true,
			type = var30,
			amount = {
				2,
				2
			}
		},
		{
			repeated = true,
			type = var26,
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
			type = var26,
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
			type = var27,
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
			type = var27,
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
			type = var27,
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
			type = var27,
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
			type = var31,
			amount = {
				8,
				10
			}
		},
		{
			repeated = true,
			type = var28,
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
			type = var28,
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
			type = var29,
			amount = {
				0,
				0
			}
		},
		{
			repeated = true,
			type = var30,
			amount = {
				2,
				2
			}
		},
		{
			repeated = true,
			type = var26,
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
			type = var26,
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
			type = var26,
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
			type = var26,
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
			type = var27,
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
			type = var27,
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
			type = var27,
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
			type = var27,
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
			type = var31,
			amount = {
				8,
				10
			}
		},
		{
			repeated = true,
			type = var28,
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
			type = var28,
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
			type = var28,
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
			type = var28,
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
			type = var29,
			amount = {
				1,
				1
			}
		},
		{
			repeated = true,
			type = var30,
			amount = {
				2,
				2
			}
		},
		{
			repeated = true,
			type = var26,
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
			type = var26,
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
			type = var26,
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
			type = var26,
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
			type = var27,
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
local var36 = {
	{
		score = 200,
		name = "fish_1",
		catch_speed = 130,
		speed = 150,
		release_speed = 200,
		type = var26,
		act = var15,
		catch = var17,
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
		good = var21
	},
	{
		score = 250,
		name = "fish_2",
		catch_speed = 75,
		speed = 100,
		leave_direct = -1,
		release_speed = 200,
		type = var26,
		act = var15,
		catch = var17,
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
		good = var20
	},
	{
		score = 400,
		name = "fish_3",
		catch_speed = 220,
		speed = 350,
		release_speed = 300,
		type = var26,
		act = var15,
		catch = var17,
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
		good = var21
	},
	{
		score = 150,
		name = "fish_4",
		catch_speed = 160,
		speed = 120,
		release_speed = 200,
		type = var26,
		act = var15,
		catch = var17,
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
		good = var21
	},
	{
		score = 180,
		name = "turtle",
		catch_speed = 100,
		speed = 80,
		release_speed = 100,
		type = var26,
		act = var15,
		catch = var17,
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
		good = var21
	},
	{
		score = -150,
		name = "submarine_1",
		speed = 200,
		catch_speed = 100,
		release_speed = 200,
		type = var27,
		act = var15,
		catch = var17,
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21,
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
		type = var27,
		act = var15,
		catch = var17,
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21,
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
		type = var27,
		act = var15,
		catch = var17,
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21,
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
		type = var27,
		act = var15,
		catch = var17,
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var21,
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
		type = var29,
		act = var15,
		catch = var16,
		move_range = {
			-300,
			1800,
			0,
			0
		},
		good = var20
	},
	{
		speed = 0,
		name = "rock",
		score = 50,
		catch_speed = 80,
		type = var28,
		act = var14,
		catch = var16,
		good = var22
	},
	{
		score = 300,
		name = "gold",
		speed = 0,
		catch_speed = 160,
		type = var28,
		act = var14,
		catch = var16,
		create_range = {
			0,
			9999,
			0,
			130
		},
		good = var19
	},
	{
		score = 600,
		name = "treasure",
		speed = 0,
		catch_speed = 55,
		type = var28,
		act = var14,
		catch = var16,
		create_range = {
			0,
			9999,
			0,
			130
		},
		good = var19
	},
	{
		score = 600,
		name = "watch",
		time = 20,
		catch_speed = 180,
		speed = 0,
		type = var30,
		act = var14,
		catch = var16,
		create_range = {
			0,
			9999,
			0,
			130
		},
		good = var19
	},
	{
		score = 200,
		name = "shell",
		speed = 0,
		catch_speed = 100,
		type = var28,
		act = var14,
		catch = var16,
		create_range = {
			0,
			9999,
			0,
			130
		},
		good = var19,
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
		type = var32,
		act = var14,
		catch = var16,
		good = var19
	},
	{
		speed = 30,
		name = "Anglerfish",
		direct = -1,
		type = var31,
		act = var15,
		scene = var23,
		catch = var18,
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
		type = var31,
		act = var15,
		scene = var23,
		catch = var18,
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
		type = var31,
		act = var15,
		scene = var23,
		catch = var18,
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
		type = var31,
		act = var15,
		scene = var23,
		catch = var18,
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
		type = var31,
		act = var15,
		scene = var23,
		catch = var18,
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
		type = var31,
		act = var15,
		scene = var23,
		catch = var18,
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
		type = var31,
		act = var15,
		scene = var23,
		catch = var18,
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
		type = var31,
		act = var15,
		scene = var23,
		catch = var18,
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
		type = var31,
		act = var15,
		scene = var23,
		catch = var18,
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
		type = var31,
		act = var15,
		scene = var23,
		catch = var18,
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
local var37 = 500
local var38 = 300
local var39 = 200
local var40 = 200
local var41 = 45
local var42 = 2.5
local var43 = 50
local var44 = 100
local var45 = 580
local var46 = 130
local var47 = {
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
local var48 = "char apply position"
local var49 = "char apply move"
local var50 = "char apply act"
local var51 = {
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
				type = var48
			},
			{
				trigger = "moveA",
				type = var50
			},
			{
				sync = true,
				offsetX = -50,
				direct = -1,
				type = var49,
				moveToX = {
					300,
					400
				}
			},
			{
				time = 2,
				trigger = "actA",
				type = var50
			},
			{
				time = 2,
				trigger = "actB",
				type = var50
			},
			{
				time = 0,
				trigger = "moveB",
				type = var50
			},
			{
				direct = -1,
				type = var49,
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
				type = var48
			},
			{
				trigger = "moveA",
				type = var50
			},
			{
				sync = true,
				offsetX = 50,
				direct = -1,
				type = var49
			},
			{
				time = 2,
				trigger = "actA",
				type = var50
			},
			{
				time = 2,
				trigger = "actB",
				type = var50
			},
			{
				time = 0,
				trigger = "moveB",
				type = var50
			},
			{
				direct = -1,
				type = var49,
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
				type = var48
			},
			{
				trigger = "move",
				type = var50
			},
			{
				direct = -1,
				type = var49,
				moveToX = {
					100,
					300
				}
			},
			{
				trigger = "act",
				type = var50
			},
			{
				direct = -1,
				type = var49,
				moveToX = {
					600,
					700
				}
			},
			{
				trigger = "act",
				type = var50
			},
			{
				direct = -1,
				type = var49,
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
				type = var48
			},
			{
				trigger = "move",
				type = var50
			},
			{
				direct = -1,
				type = var49,
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
				type = var48
			},
			{
				trigger = "move",
				type = var50
			},
			{
				direct = -1,
				type = var49,
				moveToX = {
					500,
					700
				}
			},
			{
				time = 4,
				trigger = "act",
				type = var50
			},
			{
				direct = -1,
				type = var49,
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
				type = var48
			},
			{
				trigger = "move",
				type = var50
			},
			{
				direct = -1,
				type = var49,
				moveToX = {
					-550,
					-1000
				}
			},
			{
				time = 2,
				trigger = "act",
				type = var50
			}
		}
	}
}
local var52 = {
	25,
	30
}
local var53 = {
	1,
	3,
	4,
	5,
	6
}
local var54 = {
	"actA",
	"actB"
}
local var55 = {
	10,
	15
}

local function var56(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._sceneTf = arg0
			arg0._boatTf = findTF(arg0, "boat")
			arg0._event = arg1
			arg0._hookTf = findTF(arg0._boatTf, "body/hook")
			arg0._hookContent = findTF(arg0._hookTf, "container/content")
			arg0._hookCollider = findTF(arg0._hookTf, "container/collider")
			arg0._sceneContent = findTF(arg0._sceneTf, "container/content")
			arg0.hookAnimator = GetComponent(findTF(arg0._hookTf, "bottom"), typeof(Animator))
			arg0.hookMaskAnimator = GetComponent(findTF(arg0._hookTf, "mask/img"), typeof(Animator))
			arg0.captainAnimator = GetComponent(findTF(arg0._boatTf, "body/captain/img"), typeof(Animator))

			GetComponent(findTF(arg0._boatTf, "body/captain/img"), typeof(DftAniEvent)):SetEndEvent(function()
				if arg0.inGoodAct then
					arg0.inGoodAct = false
				end
			end)

			arg0.marinerAnimator = GetComponent(findTF(arg0._boatTf, "body/mariner/img"), typeof(Animator))
		end,
		start = function(arg0)
			arg0._hookTf.sizeDelta = Vector2(0, 1)
			arg0.boatState = var11
			arg0.hookRotation = var41
			arg0.hookRotationSpeed = 0
			arg0.hookTargetRotation = var41
			arg0.throwHook = false
			arg0.inGoodAct = false

			if arg0.catchItem then
				destroy(arg0.catchItem.tf)

				arg0.catchItem = nil
			end

			arg0.marinerActTime = nil
			arg0.marinerActName = nil

			arg0:leaveItem()
		end,
		step = function(arg0)
			if arg0.boatState == var11 then
				arg0:checkChangeRotation()

				arg0.hookRotation = arg0.hookRotation + arg0:getSpringRotation()
				arg0._hookTf.localEulerAngles = Vector3(0, 0, arg0.hookRotation)
			elseif arg0.boatState == var12 then
				if arg0.throwHook then
					arg0._hookTf.sizeDelta = Vector2(0, arg0._hookTf.sizeDelta.y + var39 * Time.deltaTime)

					local var0 = math.cos(math.deg2Rad * math.abs(arg0.hookRotation))

					if arg0._hookTf.sizeDelta.y * var0 > var38 or arg0._hookTf.sizeDelta.y > var37 then
						arg0.throwHook = false
					end
				else
					local var1 = arg0:hookBack()

					if not arg0.catchItem and var1 then
						arg0.boatState = var11
					elseif arg0.catchItem then
						local var2 = arg0._hookContent.position
						local var3 = arg0._sceneContent:InverseTransformPoint(var2)

						if (arg0.catchItem.data.catch == var17 or arg0.catchItem.data.act == var15) and var3.y > var45 then
							arg0.boatState = var13

							arg0:leaveItem()
						elseif var1 then
							arg0.boatState = var13

							arg0:leaveItem()
						end
					end
				end
			elseif arg0.boatState == var13 then
				if not arg0:hookBack() then
					return
				end

				if arg0.inGoodAct then
					return
				end

				arg0.boatState = var11
			end

			if arg0.boatState == var12 and arg0.throwHook then
				arg0.hookAnimator:SetBool("hook", true)
				arg0.hookMaskAnimator:SetBool("hook", true)
			else
				arg0.hookAnimator:SetBool("hook", false)
				arg0.hookMaskAnimator:SetBool("hook", false)
			end

			if arg0.boatState == var12 then
				if arg0.throwHook then
					arg0.captainAnimator:SetInteger("state", 4)
				else
					local var4 = 1

					if arg0.catchItem then
						var4 = arg0.catchItem.data.catch_speed >= 100 and 1 or arg0.catchItem.data.catch_speed >= 50 and arg0.catchItem.data.catch_speed <= 100 and 2 or 3
					end

					arg0.captainAnimator:SetInteger("state", var4)
				end
			else
				arg0.captainAnimator:SetInteger("state", 0)
			end

			if not arg0.marinerActTime then
				arg0.marinerActTime = math.random(var55[1], var55[2])
				arg0.marinerActName = var54[math.random(1, #var54)]
			elseif arg0.marinerActTime <= 0 then
				arg0.marinerAnimator:SetTrigger(arg0.marinerActName)

				arg0.marinerActTime = math.random(var55[1], var55[2])
				arg0.marinerActName = var54[math.random(1, #var54)]
			else
				arg0.marinerActTime = arg0.marinerActTime - Time.deltaTime
			end
		end,
		hookBack = function(arg0)
			if arg0._hookTf.sizeDelta.y > 1 then
				local var0 = var40 * Time.deltaTime

				if arg0.catchItem then
					var0 = arg0.catchItem.data.catch_speed * Time.deltaTime
				end

				arg0._hookTf.sizeDelta = Vector2(0, arg0._hookTf.sizeDelta.y - var0)

				return false
			elseif arg0._hookTf.sizeDelta.y < 1 then
				arg0._hookTf.sizeDelta = Vector2(0, 1)

				return false
			end

			return true
		end,
		leaveItem = function(arg0)
			if arg0.catchItem then
				arg0._event:emit(var10, arg0.catchItem, function()
					return
				end)

				arg0.inGoodAct = true

				if arg0.catchItem.data.good == var19 then
					arg0.captainAnimator:SetTrigger("happy")
					arg0.marinerAnimator:SetTrigger("happy")
				elseif arg0.catchItem.data.good == var21 then
					arg0.captainAnimator:SetTrigger("release")
				elseif arg0.catchItem.data.good == var20 then
					arg0.captainAnimator:SetTrigger("surprise")
					arg0.marinerAnimator:SetTrigger("surprise")
				elseif arg0.catchItem.data.good == var22 then
					arg0.inGoodAct = false
				end

				arg0.catchItem = nil
			end
		end,
		throw = function(arg0)
			if arg0.boatState ~= var11 then
				return
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3)

			arg0.throwHook = true
			arg0.boatState = var12
		end,
		setCatchItem = function(arg0, arg1)
			if arg0.boatState == var12 and arg0.throwHook then
				arg0.catchItem = arg1
				arg0.throwHook = false
				arg1.tf.localScale = Vector3(math.sign(arg1.tf.localScale.x), 1, 1)

				SetParent(arg1.tf, arg0._hookContent)

				arg1.tf.anchoredPosition = Vector2(0, 0)

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4)
			end
		end,
		getSpringRotation = function(arg0)
			arg0.hookRotationSpeed = arg0.hookRotationSpeed + math.sign(arg0.hookTargetRotation) * var42

			if math.abs(arg0.hookRotationSpeed) > var43 then
				arg0.hookRotationSpeed = var43 * math.sign(arg0.hookTargetRotation)
			end

			return arg0.hookRotationSpeed * Time.deltaTime
		end,
		checkChangeRotation = function(arg0)
			if arg0.hookTargetRotation > 0 and arg0.hookRotation > arg0.hookTargetRotation then
				arg0.hookTargetRotation = -arg0.hookTargetRotation
			elseif arg0.hookTargetRotation < 0 and arg0.hookRotation < arg0.hookTargetRotation then
				arg0.hookTargetRotation = -arg0.hookTargetRotation
			end
		end,
		inCatch = function(arg0)
			return arg0.boatState == var12 and arg0.throwHook
		end,
		getHookPosition = function(arg0)
			return arg0._hookCollider.position
		end,
		gameOver = function(arg0)
			arg0.captainAnimator:SetTrigger("end")
			arg0.marinerAnimator:SetTrigger("end")
		end,
		destroy = function(arg0)
			return
		end
	}

	var0:ctor()

	return var0
end

local function var57(arg0, arg1, arg2, arg3)
	local var0 = {
		ctor = function(arg0)
			arg0._event = arg3
			arg0._sceneTpls = findTF(arg0, "sceneTpls")
			arg0._backSceneTpls = findTF(arg1, "bgTpls")
			arg0._gameMission = arg2 + 1

			local var0 = findTF(arg0, "container")

			arg0._createBounds = {
				var0.sizeDelta.x,
				var0.sizeDelta.y
			}
			arg0._parentTf = findTF(var0, "content")
			arg0._backParentTf = findTF(arg1, "container/content")
			arg0.items = {}
		end,
		getParentInversePos = function(arg0, arg1)
			local var0 = arg1.tf.position
			local var1

			if arg1.data.scene then
				if arg1.data.scene == var23 then
					var1 = arg0._backParentTf:InverseTransformPoint(var0)
				else
					var1 = arg0._parentTf:InverseTransformPoint(var0)
				end
			else
				var1 = arg0._parentTf:InverseTransformPoint(var0)
			end

			return var1
		end,
		addItemDone = function(arg0, arg1, arg2)
			local var0 = arg0:getParentInversePos(arg1)

			if arg1.data.act == var15 or arg1.data.catch == var17 then
				var0.y = var45
			end

			arg1.tf.anchoredPosition = var0

			arg0:addItemParent(arg1)

			arg1.tf.localScale = Vector3(2.5 * math.sign(arg1.tf.localScale.x), 2.5, 2.5)
			arg1.tf.localEulerAngles = Vector3(0, 0, 0)
			arg1.catchAble = false
			arg1.targetRemove = true

			if arg1.data.catch == var16 then
				GetComponent(arg1.tf, typeof(DftAniEvent)):SetEndEvent(function()
					arg0:destroyItem(arg1)
				end)
				GetComponent(arg1.tf, typeof(Animator)):SetTrigger("catch")
			elseif arg1.data.catch == var17 then
				local var1 = arg1.data.leave_direct or 1

				arg1.direct = var1
				arg1.targetX = var1 * math.sign(arg1.tf.localScale.x) == -1 and arg1.data.move_range[2] or arg1.data.move_range[1]

				GetComponent(arg1.tf, typeof(DftAniEvent)):SetEndEvent(function()
					arg1.moveAble = true
				end)

				arg1.moveAble = false

				GetComponent(arg1.tf, typeof(Animator)):SetTrigger("release")
				table.insert(arg0.items, arg1)
			end
		end,
		start = function(arg0)
			arg0:clearItems()
			arg0:prepareItems()
			arg0:setItemPosition()
		end,
		clearItems = function(arg0)
			for iter0 = #arg0.items, 1, -1 do
				local var0 = table.remove(arg0.items, iter0)

				arg0:destroyItem(var0)

				local var1
			end

			arg0.items = {}
		end,
		prepareItems = function(arg0)
			local var0 = var35[math.random(1, #var35)]

			for iter0, iter1 in pairs(var0) do
				local var1 = math.random(iter1.amount[1], iter1.amount[2])
				local var2 = iter1.type
				local var3 = iter1.repeated
				local var4 = iter1.name
				local var5 = arg0:getItemsByType(var2, var4)

				for iter2 = 1, var1 do
					local var6

					if var3 then
						var6 = var5[math.random(1, #var5)]
					elseif #var5 > 0 then
						var6 = table.remove(var5, math.random(1, #var5))
					end

					if var6 then
						local var7 = arg0:createItem(var6)

						table.insert(arg0.items, var7)
					end
				end
			end
		end,
		getItemsByType = function(arg0, arg1, arg2)
			local var0 = {}

			for iter0 = 1, #var36 do
				if var36[iter0].type == arg1 then
					if arg2 then
						if table.contains(arg2, var36[iter0].name) then
							table.insert(var0, var36[iter0])
						end
					else
						table.insert(var0, var36[iter0])
					end
				end
			end

			return var0
		end,
		getItemDataByName = function(arg0, arg1)
			for iter0 = 1, #var36 do
				if var36[iter0].name == arg1 then
					return var36[iter0]
				end
			end

			return nil
		end,
		createItem = function(arg0, arg1)
			local var0 = {
				data = arg1
			}

			var0.tf = nil
			var0.targetX = nil
			var0.targetY = nil
			var0.direct = arg1.direct or 1
			var0.moveAble = true
			var0.catchAble = true
			var0.targetRemove = false
			var0.interaction = arg1.interaction and true or false
			var0.interactionName = nil
			var0.interactionTime = nil
			var0.animStateIndex = nil
			var0.nextAnimTime = nil

			arg0:instantiateItem(var0)

			return var0
		end,
		instantiateItem = function(arg0, arg1)
			local var0

			if arg1.data.scene == var23 then
				var0 = findTF(arg0._backSceneTpls, arg1.data.name)
			else
				var0 = findTF(arg0._sceneTpls, arg1.data.name)
			end

			local var1 = Instantiate(var0)

			arg1.tf = tf(var1)

			setActive(arg1.tf, true)
			arg0:addItemParent(arg1)
		end,
		addItemParent = function(arg0, arg1)
			if arg1.data.scene then
				if arg1.data.scene == var23 then
					SetParent(arg1.tf, arg0._backParentTf)
				else
					SetParent(arg1.tf, arg0._parentTf)
				end
			else
				SetParent(arg1.tf, arg0._parentTf)
			end
		end,
		setItemPosition = function(arg0)
			if not arg0.items or #arg0.items == 0 then
				return
			end

			local var0 = arg0:splitePositions(0, arg0._createBounds[1])
			local var1 = arg0:splitePositions(0, arg0._createBounds[2])
			local var2 = arg0:mixSplitePos(var0, var1)

			local function var3(arg0)
				if arg0 then
					local var0 = {}

					for iter0 = 1, #var2 do
						local var1 = iter0
						local var2 = var2[iter0]
						local var3 = arg0[1]
						local var4 = arg0[2]
						local var5 = arg0[3]
						local var6 = arg0[4]
						local var7 = var2[1][1]
						local var8 = var2[1][2]
						local var9 = var2[2][1]
						local var10 = var2[2][2]

						if var3 <= var7 and var8 <= var4 and var5 <= var9 and var10 <= var6 then
							table.insert(var0, var1)
						end
					end

					if #var0 > 0 then
						return table.remove(var2, var0[math.random(1, #var0)])
					end
				end

				if #var2 > 0 then
					return table.remove(var2, math.random(1, #var2))
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

			for iter0 = 1, #arg0.items do
				local var4 = var3(arg0.items[iter0].data.create_range)

				if var4 then
					local var5 = var4[1][1] + math.random() * (var4[1][2] - var4[1][1]) / 2
					local var6 = var4[2][1] + math.random() * (var4[2][2] - var4[2][1]) / 2

					arg0.items[iter0].tf.anchoredPosition = Vector2(var5, var6)
				end
			end
		end,
		mixSplitePos = function(arg0, arg1, arg2)
			local var0 = {}

			for iter0 = 1, #arg1 do
				local var1 = arg1[iter0]

				for iter1 = 1, #arg2 do
					local var2 = arg2[iter1]

					table.insert(var0, {
						var1,
						var2
					})
				end
			end

			return var0
		end,
		splitePositions = function(arg0, arg1, arg2)
			local var0 = {}

			if not arg1 or not arg2 or arg2 < arg1 then
				return nil
			end

			local var1 = (arg2 - arg1) / var46

			for iter0 = 1, var1 do
				table.insert(var0, {
					arg1 + (iter0 - 1) * var46,
					arg1 + iter0 * var46
				})
			end

			return var0
		end,
		getItemByPos = function(arg0, arg1)
			local var0 = arg0:checkPosInCollider(arg1)

			if var0 then
				if var0.data.catch_rule then
					local var1 = GetComponent(var0.tf, typeof(Animator)):GetInteger("state")
					local var2 = var0.data.catch_rule.state

					if table.contains(var2, var1) then
						arg0:addItemDone(var0)

						return (arg0:createItem(arg0:getItemDataByName(var0.data.catch_rule.targetName)))
					end
				else
					return var0
				end

				return var0
			end

			return nil
		end,
		checkPosInCollider = function(arg0, arg1)
			local var0 = {}
			local var1 = arg0._parentTf:InverseTransformPoint(arg1.x, arg1.y, arg1.z)

			for iter0 = 1, #arg0.items do
				if arg0.items[iter0].data.catch ~= var18 then
					local var2 = arg0.items[iter0].tf

					if math.abs(var1.x - var2.anchoredPosition.x) < var44 and math.abs(var1.y - var2.anchoredPosition.y) < var44 and arg0.items[iter0].data.catch ~= var18 and arg0.items[iter0].catchAble then
						table.insert(var0, arg0.items[iter0])
					end
				end
			end

			for iter1 = 1, #var0 do
				local var3 = findTF(var0[iter1].tf, "collider")

				if not var3 then
					print("can not find collider by" .. var0[iter1].data.name)
				else
					local var4 = var3:InverseTransformPoint(arg1.x, arg1.y, arg1.z)
					local var5 = var3.rect.xMin
					local var6 = var3.rect.yMin
					local var7 = var3.rect.width
					local var8 = var3.rect.height

					if arg0:isPointInMatrix(Vector2(var5, var6 + var8), Vector2(var5 + var7, var6 + var8), Vector2(var5 + var7, var6), Vector2(var5, var6), var4) then
						return arg0:removeItem(var0[iter1])
					end
				end
			end

			return nil
		end,
		removeItem = function(arg0, arg1)
			for iter0 = 1, #arg0.items do
				if arg0.items[iter0] == arg1 then
					return table.remove(arg0.items, iter0)
				end
			end
		end,
		getCross = function(arg0, arg1, arg2, arg3)
			return (arg2.x - arg1.x) * (arg3.y - arg1.y) - (arg3.x - arg1.x) * (arg2.y - arg1.y)
		end,
		isPointInMatrix = function(arg0, arg1, arg2, arg3, arg4, arg5)
			return arg0:getCross(arg1, arg2, arg5) * arg0:getCross(arg3, arg4, arg5) >= 0 and arg0:getCross(arg2, arg3, arg5) * arg0:getCross(arg4, arg1, arg5) >= 0
		end,
		step = function(arg0)
			for iter0 = #arg0.items, 1, -1 do
				local var0 = arg0.items[iter0]

				if var0.data.act == var15 and var0.moveAble then
					if not var0.targetX then
						local var1 = var0.data.move_range[1]
						local var2 = var0.data.move_range[2]

						if var0.tf.anchoredPosition.x == var1 then
							var0.targetX = var2
						elseif var0.tf.anchoredPosition.x == var2 then
							var0.targetX = var1
						else
							var0.targetX = math.random() > 0.5 and var1 or var2
						end
					else
						local var3 = math.sign(var0.targetX - var0.tf.anchoredPosition.x)
						local var4 = var0.targetRemove and var0.data.release_speed or var0.data.speed

						var0.tf.localScale = Vector3(-1 * var3 * var0.direct * math.abs(var0.tf.localScale.x), var0.tf.localScale.y, var0.tf.localScale.z)

						local var5 = var3 * var4 * Time.deltaTime

						var0.tf.anchoredPosition = Vector2(var0.tf.anchoredPosition.x + var5, var0.tf.anchoredPosition.y)

						if var3 == 1 and var0.tf.anchoredPosition.x >= var0.targetX or var3 == -1 and var0.tf.anchoredPosition.x <= var0.targetX then
							var0.tf.anchoredPosition = Vector2(var0.targetX, var0.tf.anchoredPosition.y)
							var0.targetX = nil
						end
					end
				end

				if var0.data.anim_data then
					local var6 = var0.data.anim_data.state_change
					local var7 = var0.data.anim_data.time

					if var6 and var7 then
						if not var0.nextAnimTime then
							var0.nextAnimTime = math.random(var7[1], var7[2])
							var0.animStateIndex = 1
						elseif var0.nextAnimTime <= 0 then
							GetComponent(var0.tf, typeof(Animator)):SetInteger("state", var6[var0.animStateIndex])

							var0.nextAnimTime = math.random(var7[1], var7[2])
							var0.animStateIndex = var0.animStateIndex + 1
							var0.animStateIndex = var0.animStateIndex > #var6 and 1 or var0.animStateIndex
						else
							var0.nextAnimTime = var0.nextAnimTime - Time.deltaTime
						end
					end
				end

				if var0.interaction and not var0.targetRemove then
					if not var0.interactionTime then
						var0.interactionTime = math.random() * (var0.data.interaction.time[2] - var0.data.interaction.time[1]) + var0.data.interaction.time[1]
						var0.interactionName = var0.data.interaction.parame[math.random(1, #var0.data.interaction.parame)]
					elseif var0.interactionTime <= 0 then
						GetComponent(var0.tf, typeof(Animator)):SetTrigger(var0.interactionName)

						var0.interactionTime = nil
						var0.interactionName = nil
					else
						var0.interactionTime = var0.interactionTime - Time.deltaTime
					end
				end

				if var0.targetRemove and not var0.targetX then
					table.remove(arg0.items, iter0)
					arg0:destroyItem(var0)
				end
			end
		end,
		destroyItem = function(arg0, arg1)
			destroy(arg1.tf)
		end,
		destroy = function(arg0)
			return
		end
	}

	var0:ctor()

	return var0
end

local function var58(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._boatController = arg0
			arg0._itemController = arg1
		end,
		start = function(arg0)
			return
		end,
		step = function(arg0)
			if arg0._boatController:inCatch() then
				local var0 = arg0._boatController:getHookPosition()
				local var1 = arg0._itemController:getItemByPos(var0)

				if var1 then
					GetComponent(var1.tf, typeof(Animator)):SetTrigger("hold")
					arg0._boatController:setCatchItem(var1)
				end
			end
		end,
		destroy = function(arg0)
			return
		end
	}

	var0:ctor()

	return var0
end

local function var59(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._charTpls = findTF(arg0, "charTpls")
			arg0._content = findTF(arg0, "charContainer/content")
			arg0._event = arg1
		end,
		start = function(arg0)
			arg0:clear()

			arg0.chars = {}
			arg0.nextTime = math.random(var52[1], var52[2])
			arg0.showChars = Clone(var53)
		end,
		step = function(arg0)
			if arg0.nextTime <= 0 and #arg0.showChars > 0 then
				table.insert(arg0.chars, arg0:createChar())

				arg0.nextTime = math.random(var52[1], var52[2])
			else
				arg0.nextTime = arg0.nextTime - Time.deltaTime
			end

			arg0:setCharAction()

			for iter0 = #arg0.chars, 1, -1 do
				arg0:stepChar(arg0.chars[iter0])

				if arg0.chars[iter0].removeFlag then
					arg0:removeChar(table.remove(arg0.chars, iter0))
				end
			end
		end,
		stepChar = function(arg0, arg1)
			local var0 = false

			if arg1.posX then
				arg1.tf.anchoredPosition = Vector2(arg1.posX + (arg1.offsetX or 0), 0)

				setActive(arg1.tf, true)

				arg1.posX = nil
				arg1.offsetX = nil
			end

			if arg1.moveToX then
				local var1 = arg1.moveToX + arg1.offsetX
				local var2 = arg1.tf.anchoredPosition
				local var3 = math.sign(var1 - var2.x)

				arg1.tf.anchoredPosition = Vector3(var2.x + var3 * arg1.speed, 0)

				local var4 = math.sign(var2.x - var1)
				local var5 = math.sign(arg1.tf.anchoredPosition.x - var1)

				if arg1.tf.anchoredPosition.x == var1 or var4 ~= var5 then
					arg1.moveToX = nil
					arg1.offsetX = nil
				else
					var0 = true
				end
			end

			if arg1.triggerName or arg1.time then
				if arg1.triggerName and arg1.animator then
					arg1.animator:SetTrigger(arg1.triggerName)

					arg1.triggerName = nil
				end

				arg1.time = arg1.time - Time.deltaTime

				if arg1.triggerName == nil and arg1.time <= 0 then
					arg1.time = nil
				else
					var0 = true
				end
			end

			arg1.inAction = var0
		end,
		getRandomMoveX = function(arg0, arg1, arg2)
			return arg1 + math.random(0, arg2 - arg1)
		end,
		removeChar = function(arg0, arg1)
			if arg1.bindChars then
				arg1.bindChars = {}
			end

			destroy(arg1.tf)
		end,
		setCharAction = function(arg0)
			for iter0 = 1, #arg0.chars do
				local var0 = arg0.chars[iter0]

				if not var0.currentActionInfo and #var0.actionInfos > 0 and not var0.inAction then
					if var0.sync and var0.bindIds and #var0.bindIds > 0 then
						local var1 = true

						for iter1, iter2 in ipairs(var0.bindChars) do
							if iter2.inAction or not iter2.sync then
								var1 = false
							end
						end

						if var1 then
							var0.currentActionInfo = table.remove(var0.actionInfos, 1)

							for iter3, iter4 in ipairs(var0.bindChars) do
								iter4.sync = false
							end
						end
					elseif not var0.sync then
						var0.currentActionInfo = table.remove(var0.actionInfos, 1)
					end
				end

				if var0.currentActionInfo and not var0.currentActionInfo.sync then
					arg0:addCharAction(var0)
				elseif var0.currentActionInfo and var0.currentActionInfo.sync and var0.bindIds then
					arg0:addCharAction(var0)

					for iter5, iter6 in ipairs(var0.bindChars) do
						if iter6 and iter6.currentActionInfo and iter6.currentActionInfo.sync then
							arg0:addBindCharAction(var0, iter6)
						end
					end
				elseif not var0.currentActionInfo and #var0.actionInfos == 0 and not var0.inAction then
					var0.removeFlag = true
				end
			end
		end,
		addBindCharAction = function(arg0, arg1, arg2)
			if arg2.currentActionInfo.type == var49 then
				arg2.moveToX = arg1.moveToX
				arg2.offsetX = arg2.currentActionInfo.offsetX or 0
			elseif arg2.currentActionInfo.type == var48 then
				-- block empty
			elseif arg2.currentActionInfo.type == var50 then
				-- block empty
			end

			arg2.sync = arg2.currentActionInfo.sync
			arg2.currentActionInfo = nil
			arg2.inAction = true
		end,
		addCharAction = function(arg0, arg1)
			local var0 = arg1.currentActionInfo.type

			if var0 == var49 then
				local var1

				if arg1.currentActionInfo.moveToX then
					var1 = arg0:getRandomMoveX(arg1.currentActionInfo.moveToX[1], arg1.currentActionInfo.moveToX[2])
				end

				arg1.moveToX = var1 or 0
				arg1.offsetX = arg1.currentActionInfo.offsetX or 0
			elseif var0 == var48 then
				arg1.posX = arg1.currentActionInfo.posX or 0
				arg1.offsetX = arg1.currentActionInfo.offsetX or 0
			elseif var0 == var50 then
				arg1.triggerName = arg1.currentActionInfo.trigger
				arg1.time = arg1.currentActionInfo.time or 0
			end

			arg1.sync = arg1.currentActionInfo.sync
			arg1.inAction = true
			arg1.currentActionInfo = nil
		end,
		createChar = function(arg0, arg1)
			local var0 = {}
			local var1 = Clone(arg1) or arg0:getRandomData()

			if not var1 then
				return
			end

			var0.data = var1
			var0.id = var1.id
			var0.bindIds = var1.bindIds
			var0.bindChars = {}
			var0.actionInfos = var1.actions
			var0.speed = var1.speed
			var0.tf = arg0:getCharTf(var1.tf)
			var0.animator = GetComponent(findTF(var0.tf, "anim"), typeof(Animator))
			var0.dft = GetComponent(findTF(var0.tf, "anim"), typeof(DftAniEvent))
			var0.currentActionInfo = nil
			var0.posX = nil
			var0.moveToX = nil
			var0.offsetX = nil
			var0.triggerName = nil
			var0.time = nil
			var0.inAction = false
			var0.removeFlag = false

			if var0.bindIds then
				for iter0 = 1, #var0.bindIds do
					local var2 = arg0:createChar(arg0:getCharDataById(var0.bindIds[iter0]))

					table.insert(arg0.chars, var2)
					table.insert(var0.bindChars, var2)
				end
			end

			return var0
		end,
		getRandomData = function(arg0)
			if arg0.showChars and #arg0.showChars > 0 then
				local var0 = table.remove(arg0.showChars, math.random(1, #arg0.showChars))

				return arg0:getCharDataById(var0)
			end

			return nil
		end,
		getCharDataById = function(arg0, arg1)
			for iter0, iter1 in ipairs(var51) do
				if iter1.id == arg1 then
					return Clone(iter1)
				end
			end
		end,
		getCharTf = function(arg0, arg1)
			local var0 = tf(instantiate(findTF(arg0._charTpls, arg1)))

			SetParent(var0, arg0._content)
			SetActive(var0, false)

			return var0
		end,
		clear = function(arg0)
			if arg0.chars then
				for iter0 = #arg0.chars, 1, -1 do
					arg0:removeChar(table.remove(arg0.chars, iter0))
				end

				arg0.chars = {}
			end
		end
	}

	var0:ctor()

	return var0
end

function var0.getUIName(arg0)
	return "CatchTreasureGameUI"
end

function var0.getBGM(arg0)
	return var1
end

function var0.didEnter(arg0)
	arg0:initEvent()
	arg0:initData()
	arg0:initUI()
	arg0:initGameUI()
	arg0:updateMenuUI()
	arg0:openMenuUI()
end

function var0.initEvent(arg0)
	arg0:bind(var10, function(arg0, arg1, arg2)
		if arg0.itemController then
			arg0.itemController:addItemDone(arg1, arg2)
		end

		arg0:addScore(arg1.data.score, arg1.data.time)
	end)
end

function var0.initData(arg0)
	arg0.dropData = pg.mini_game[arg0:GetMGData().id].simple_config_data.drop

	local var0 = Application.targetFrameRate or 60

	if var0 > 60 then
		var0 = 60
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var0, -1)
end

function var0.initUI(arg0)
	arg0.backSceneTf = findTF(arg0._tf, "scene_container/scene_background")
	arg0.sceneTf = findTF(arg0._tf, "scene_container/scene")
	arg0.bgTf = findTF(arg0._tf, "bg")
	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetOrAddComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:gameStart()
	end)
	SetActive(arg0.countUI, false)

	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	onButton(arg0, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0.leaveUI, false)

	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	onButton(arg0, findTF(arg0.pauseUI, "ad/btnOk"), function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0.pauseUI, false)

	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	onButton(arg0, findTF(arg0.settlementUI, "ad/btnOver"), function()
		setActive(arg0.settlementUI, false)
		arg0:openMenuUI()
	end, SFX_CANCEL)
	SetActive(arg0.settlementUI, false)

	arg0.menuUI = findTF(arg0._tf, "pop/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
	arg0.titleDesc = findTF(arg0.menuUI, "desc")

	GetComponent(arg0.titleDesc, typeof(Image)):SetNativeSize()

	arg0.totalTimes = arg0:getGameTotalTime()

	local var0 = arg0:getGameUsedTimes() - 4 < 0 and 0 or arg0:getGameUsedTimes() - 4

	scrollTo(arg0.battleScrollRect, 0, 1 - var0 / (arg0.totalTimes - 4))
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowUp"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowDown"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var9].tip
		})
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnStart"), function()
		setActive(arg0.menuUI, false)
		arg0:readyStart()
	end, SFX_CANCEL)

	local var1 = findTF(arg0.menuUI, "tplBattleItem")

	arg0.battleItems = {}
	arg0.dropItems = {}

	for iter0 = 1, 7 do
		local var2 = tf(instantiate(var1))

		var2.name = "battleItem_" .. iter0

		setParent(var2, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var3 = iter0

		GetSpriteFromAtlasAsync(var8, "buttomDesc" .. var3, function(arg0)
			setImageSprite(findTF(var2, "state_open/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_clear/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_current/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_closed/buttomDesc"), arg0, true)
		end)

		local var4 = findTF(var2, "icon")
		local var5 = {
			type = arg0.dropData[iter0][1],
			id = arg0.dropData[iter0][2],
			count = arg0.dropData[iter0][3]
		}

		updateDrop(var4, var5)
		onButton(arg0, var4, function()
			arg0:emit(BaseUI.ON_DROP, var5)
		end, SFX_PANEL)
		table.insert(arg0.dropItems, var4)
		setActive(var2, true)
		table.insert(arg0.battleItems, var2)
	end

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.initGameUI(arg0)
	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")

	onButton(arg0, findTF(arg0.gameUI, "topRight/btnStop"), function()
		arg0:stopGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnLeave"), function()
		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end)

	arg0.dragDelegate = GetOrAddComponent(arg0.sceneTf, "EventTriggerListener")
	arg0.dragDelegate.enabled = true

	arg0.dragDelegate:AddPointDownFunc(function(arg0, arg1)
		if arg0.boatController then
			arg0.boatController:throw()
		end
	end)

	arg0.gameTimeS = findTF(arg0.gameUI, "top/time/s")
	arg0.scoreTf = findTF(arg0.gameUI, "top/score")
	arg0.boatController = var56(arg0.sceneTf, arg0)
	arg0.itemController = var57(arg0.sceneTf, arg0.backSceneTf, arg0:getGameUsedTimes(), arg0)
	arg0.catchController = var58(arg0.boatController, arg0.itemController)
	arg0.charController = var59(arg0.backSceneTf, arg0)
	arg0.sceneScoreTf = findTF(arg0.sceneTf, "scoreTf")

	setActive(arg0.sceneScoreTf, false)
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0.updateMenuUI(arg0)
	local var0 = arg0:getGameUsedTimes()
	local var1 = arg0:getGameTimes()

	for iter0 = 1, #arg0.battleItems do
		setActive(findTF(arg0.battleItems[iter0], "state_open"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_closed"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_clear"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_current"), false)

		if iter0 <= var0 then
			setActive(findTF(arg0.battleItems[iter0], "state_clear"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_clear/icon"))
			setActive(arg0.dropItems[iter0], true)

			arg0.dropItems[iter0].anchoredPosition = Vector2(0, 0)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0.battleItems[iter0], "state_current"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_current/icon"))
			setActive(arg0.dropItems[iter0], true)

			arg0.dropItems[iter0].anchoredPosition = Vector2(0, 0)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			setActive(findTF(arg0.battleItems[iter0], "state_open"), true)
			SetParent(arg0.dropItems[iter0], findTF(arg0.battleItems[iter0], "state_open/icon"))
			setActive(arg0.dropItems[iter0], true)

			arg0.dropItems[iter0].anchoredPosition = Vector2(0, 0)
		else
			setActive(findTF(arg0.battleItems[iter0], "state_closed"), true)
			setActive(arg0.dropItems[iter0], false)
		end
	end

	arg0.totalTimes = arg0:getGameTotalTime()

	local var2 = 1 - (arg0:getGameUsedTimes() - 3 < 0 and 0 or arg0:getGameUsedTimes() - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.battleScrollRect, 0, var2)
	setActive(findTF(arg0.menuUI, "btnStart/tip"), var1 > 0)
	arg0:CheckGet()
end

function var0.CheckGet(arg0)
	setActive(findTF(arg0.menuUI, "got"), false)

	if arg0:getUltimate() and arg0:getUltimate() ~= 0 then
		setActive(findTF(arg0.menuUI, "got"), true)
	end

	if arg0:getUltimate() == 0 then
		if arg0:getGameTotalTime() > arg0:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0.menuUI, "got"), true)
	end
end

function var0.openMenuUI(arg0)
	setActive(findTF(arg0._tf, "scene_container"), false)
	setActive(findTF(arg0.bgTf, "on"), true)
	setActive(arg0.gameUI, false)
	setActive(arg0.menuUI, true)
	arg0:updateMenuUI()
end

function var0.clearUI(arg0)
	setActive(arg0.sceneTf, false)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
	setActive(arg0.menuUI, false)
	setActive(arg0.gameUI, false)
end

function var0.readyStart(arg0)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2)
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.getGameUsedTimes(arg0)
	return arg0:GetMGHubData().usedtime
end

function var0.getUltimate(arg0)
	return arg0:GetMGHubData().ultimate
end

function var0.getGameTotalTime(arg0)
	return (arg0:GetMGHubData():getConfig("reward_need"))
end

function var0.gameStart(arg0)
	setActive(findTF(arg0._tf, "scene_container"), true)
	setActive(findTF(arg0.bgTf, "on"), false)
	setActive(arg0.gameUI, true)

	arg0.gameStartFlag = true
	arg0.scoreNum = 0
	arg0.playerPosIndex = 2
	arg0.gameStepTime = 0
	arg0.heart = 3
	arg0.gameTime = var7

	SetActive(arg0.sceneScoreTf, false)

	if arg0.boatController then
		arg0.boatController:start()
	end

	if arg0.itemController then
		arg0.itemController:start()
	end

	if arg0.catchController then
		arg0.catchController:start()
	end

	if arg0.charController then
		arg0.charController:start()
	end

	arg0:updateGameUI()
	arg0:timerStart()
end

function var0.transformColor(arg0, arg1)
	local var0 = tonumber(string.sub(arg1, 1, 2), 16)
	local var1 = tonumber(string.sub(arg1, 3, 4), 16)
	local var2 = tonumber(string.sub(arg1, 5, 6), 16)

	return Color.New(var0 / 255, var1 / 255, var2 / 255)
end

function var0.addScore(arg0, arg1, arg2)
	if arg1 and arg1 > 0 or arg2 and arg2 > 0 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5)
	elseif arg1 and arg1 < 0 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var6)
	end

	setActive(arg0.sceneScoreTf, false)

	local var0 = findTF(arg0.sceneScoreTf, "img")
	local var1 = GetComponent(var0, typeof(Text))
	local var2 = "6f1807"

	if arg1 then
		local var3

		for iter0 = 1, #var47 do
			if arg1 and arg1 >= var47[iter0].score then
				var2 = var47[iter0].color
				var3 = var47[iter0].font

				break
			end
		end

		local var4 = arg0:transformColor(var2)

		arg0.scoreNum = arg0.scoreNum + arg1

		local var5 = arg1 >= 0 and "+" or ""

		setText(var0, var5 .. arg1)

		var1.fontSize = var3 or 40

		setTextColor(var0, var4)
	elseif arg2 then
		local var6 = arg0:transformColor("66f2fb")

		var1.fontSize = 40

		setTextColor(var0, var6)

		if arg0.gameTime > 0 then
			arg0.gameTime = arg0.gameTime + arg2
		end

		local var7 = arg2 > 0 and "+" or ""

		setText(var0, var7 .. arg2 .. "s")
	end

	setActive(arg0.sceneScoreTf, true)
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	arg0.gameTime = arg0.gameTime - Time.deltaTime
	arg0.gameStepTime = arg0.gameStepTime + Time.deltaTime

	if arg0.boatController then
		arg0.boatController:step()
	end

	if arg0.itemController then
		arg0.itemController:step()
	end

	if arg0.catchController then
		arg0.catchController:step()
	end

	if arg0.charController then
		arg0.charController:step()
	end

	if arg0.gameTime < 0 then
		arg0.gameTime = 0
	end

	arg0:updateGameUI()

	if arg0.gameTime <= 0 then
		arg0:onGameOver()

		return
	end
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.updateGameUI(arg0)
	setText(arg0.scoreTf, arg0.scoreNum)
	setText(arg0.gameTimeS, math.ceil(arg0.gameTime))
end

function var0.onGameOver(arg0)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()

	arg0.settlementFlag = true

	setActive(arg0.clickMask, true)

	if arg0.boatController then
		arg0.boatController:gameOver()
	end

	LeanTween.delayedCall(go(arg0._tf), 2, System.Action(function()
		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0:showSettlement()
	end))
end

function var0.showSettlement(arg0)
	setActive(arg0.settlementUI, true)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	setActive(findTF(arg0.settlementUI, "ad/new"), var2 < var1)

	if var2 <= var1 then
		var2 = var1

		arg0:StoreDataToServer({
			var2
		})
	end

	local var3 = findTF(arg0.settlementUI, "ad/highText")
	local var4 = findTF(arg0.settlementUI, "ad/currentText")

	setText(var3, var2)
	setText(var4, var1)

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0.sendSuccessFlag = true

		arg0:SendSuccess(0)
	end
end

function var0.resumeGame(arg0)
	arg0.gameStop = false

	setActive(arg0.leaveUI, false)
	arg0:timerStart()
end

function var0.stopGame(arg0)
	arg0.gameStop = true

	arg0:timerStop()
end

function var0.onBackPressed(arg0)
	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		if arg0.settlementFlag then
			return
		end

		if isActive(arg0.pauseUI) then
			setActive(arg0.pauseUI, false)
		end

		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if arg0._tf and LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	Time.timeScale = 1
	arg0.timer = nil
end

return var0
