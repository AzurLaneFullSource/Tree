local var0 = class("HideSeekGameView", import("..BaseMiniGameView"))
local var1 = "bar-soft"
local var2 = "event:/ui/ddldaoshu2"
local var3 = "event:/ui/break_out_full"
local var4 = "hideseekgameui_atlas"
local var5 = 60
local var6 = {
	{
		25,
		0.8,
		1
	},
	{
		45,
		1.2,
		1.4
	},
	{
		60,
		1.6,
		1.8
	}
}
local var7 = 100
local var8 = 2
local var9 = 50
local var10 = 400
local var11 = 400
local var12 = "on_touch_furniture"
local var13 = 1
local var14 = 2
local var15 = 3
local var16 = 4
local var17 = "HideSeekBath"
local var18 = "HideSeekBed"
local var19 = "HideSeekFridge"
local var20 = "HideSeekHakoCL"
local var21 = "HideSeekHakoCR"
local var22 = "HideSeekUpR"
local var23 = "HideSeekUpL"
local var24 = "HideSeekDeskUnder"
local var25 = "HideSeekSofaS"
local var26 = "HideSeekSofaL"
local var27 = "HideSeekHakoSL"
local var28 = "HideSeekHakoSR"
local var29 = "HideSeekHakoML"
local var30 = "HideSeekHakoMR"
local var31 = "HideSeekDeskSR"
local var32 = "HideSeekDeskSL"
local var33 = "HideSeekDeskStudyL"
local var34 = "HideSeekDeskStudyR"
local var35 = "HideSeekCushion"
local var36 = "ui/minigameui/hideseek"
local var37 = 3
local var38 = {
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8
}
local var39 = {
	{
		name = "furniture_bath",
		pos_data_list = {
			{
				pos_name = "posBath",
				anim_name = var17
			}
		},
		type = var13
	},
	{
		weight = 0.2,
		name = "furniture_bed",
		pos_data_list = {
			{
				pos_name = "posBed",
				anim_name = var18
			}
		},
		type = var14
	},
	{
		name = "furniture_Fridge",
		time = 3,
		defaut_trigger = true,
		defaut_char_index = 9,
		weight = 0.15,
		pos_data_list = {
			{
				pos_name = "posFridge",
				anim_name = var19
			}
		},
		type = var15
	},
	{
		time = 4,
		name = "furniture_Hako_L1",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoCL",
				anim_name = var20
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Cook",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posUpR",
				anim_name = var22
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Desk_Dining",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posUnder",
				anim_name = var24
			},
			{
				pos_name = "posUpR",
				anim_name = var22
			},
			{
				pos_name = "posUpL",
				anim_name = var23
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Sofa_S",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posSofaS",
				anim_name = var25
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Sofa_L",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posSofaL",
				anim_name = var26
			},
			{
				pos_name = "posUpL",
				anim_name = var23
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Hako_S1_3",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoSL",
				anim_name = var27
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Desk_S",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posDeskSL",
				anim_name = var32
			},
			{
				pos_name = "posDeskSR",
				anim_name = var31
			},
			{
				pos_name = "posDeskUnder",
				anim_name = var24
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Hako_L2",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoCL",
				anim_name = var20
			},
			{
				pos_name = "posHakoCR",
				anim_name = var21
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Desk_Study",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posDeskStudyL",
				anim_name = var33
			},
			{
				pos_name = "posDeskStudyR",
				anim_name = var34
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Hako_M1",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoML",
				anim_name = var29
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Hako_M2",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoMR",
				anim_name = var30
			}
		},
		type = var13
	},
	{
		time = 4,
		name = "furniture_Hako_S2",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoSR",
				anim_name = var28
			}
		},
		type = var13
	},
	{
		name = "furniture_Manjuu_cushion",
		pos_data_list = {
			{
				pos_name = "posCushion",
				anim_name = var35
			}
		},
		type = var13,
		hide_tfs = {
			"img"
		}
	}
}
local var40 = {
	HideSeekBath = {
		prefab = "hideseekbath.prefab",
		name = var17,
		ignore_char = {}
	},
	HideSeekBed = {
		prefab = "hideseekbed.prefab",
		name = var18,
		ignore_char = {}
	},
	HideSeekFridge = {
		prefab = "hideseekfridge.prefab",
		name = var19,
		ignore_char = {}
	},
	HideSeekHakoCL = {
		prefab = "hideseekhakocl.prefab",
		name = var20,
		ignore_char = {}
	},
	HideSeekHakoCR = {
		prefab = "hideseekhakocr.prefab",
		name = var21,
		ignore_char = {}
	},
	HideSeekUpR = {
		prefab = "hideseekupr.prefab",
		name = var22,
		ignore_char = {}
	},
	HideSeekUpL = {
		prefab = "hideseekupl.prefab",
		name = var23,
		ignore_char = {}
	},
	HideSeekDeskUnder = {
		prefab = "hideseekdeskunder.prefab",
		name = var24,
		ignore_char = {}
	},
	HideSeekSofaS = {
		prefab = "hideseeksofas.prefab",
		name = var25,
		ignore_char = {}
	},
	HideSeekSofaL = {
		prefab = "hideseeksofal.prefab",
		name = var26,
		ignore_char = {}
	},
	HideSeekHakoSL = {
		prefab = "hideseekhakosl.prefab",
		name = var27,
		ignore_char = {}
	},
	HideSeekHakoSR = {
		prefab = "hideseekhakosr.prefab",
		name = var28,
		ignore_char = {}
	},
	HideSeekDeskSL = {
		prefab = "hideseekdesksl.prefab",
		name = var32,
		ignore_char = {}
	},
	HideSeekDeskSR = {
		prefab = "hideseekdesksr.prefab",
		name = var31,
		ignore_char = {}
	},
	HideSeekDeskStudyL = {
		prefab = "hideseekdeskstudyl.prefab",
		name = var33,
		ignore_char = {}
	},
	HideSeekDeskStudyR = {
		prefab = "hideseekdeskstudyr.prefab",
		name = var34,
		ignore_char = {}
	},
	HideSeekHakoML = {
		prefab = "hideseekhakoml.prefab",
		name = var29,
		ignore_char = {}
	},
	HideSeekHakoMR = {
		prefab = "hideseekhakomr.prefab",
		name = var30,
		ignore_char = {}
	},
	HideSeekCushion = {
		prefab = "hideseekcushion.prefab",
		name = var35,
		ignore_char = {}
	}
}
local var41 = 0.1
local var42 = {
	-475,
	652
}
local var43 = {
	-335,
	290
}
local var44 = Vector2(150, -200)
local var45 = "hideseektv.prefab"
local var46 = {}

local function var47(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._event = arg1
			arg0._sceneTf = arg0
			arg0._tplContainer = findTF(arg0, "tplPos")
			var46 = Clone(var38)
			arg0._furnituresPools = {}

			for iter0 = 1, #var39 do
				local var0 = Clone(var39[iter0])
				local var1 = findTF(arg0._sceneTf, var39[iter0].name)

				table.insert(arg0._furnituresPools, {
					activeIndex = 0,
					data = var0,
					tf = var1
				})
			end

			arg0._unActiveFurnitures = {}
			arg0._activeFurnitures = {}
			arg0._furnitureAnimTfPool = {}
			arg0._animTplDic = {}
		end,
		start = function(arg0)
			arg0.timeStep = 0

			arg0:clear()

			arg0.timeAppear = 0
			arg0.additiveScore = var7

			for iter0 = #arg0._furnituresPools, 1, -1 do
				local var0 = arg0._furnituresPools[iter0]

				if var0.data.type == var14 then
					if math.random() <= var0.data.weight then
						arg0:appearChar(var0.data.name)
					end

					var0.initFlag = true

					table.insert(arg0._unActiveFurnitures, arg0:getFunitureFromPool(var0.data.name))
				elseif var0.data.type == var15 then
					arg0:appearChar(var0.data.name)
				end
			end
		end,
		step = function(arg0)
			arg0.timeStep = arg0.timeStep + Time.deltaTime

			local var0 = false

			if arg0.timeAppear <= 0 then
				var0 = true

				local var1 = var5 - arg0.timeStep

				arg0.timeAppear = nil

				for iter0 = 1, #var6 do
					if not arg0.timeAppear and var1 < var6[iter0][1] or iter0 == #var6 then
						local var2 = var6[iter0][2]
						local var3 = var6[iter0][3]

						arg0.timeAppear = math.random() * (var3 - var2) + var2

						break
					end
				end

				arg0.timeAppear = not arg0.timeAppear and 2 or arg0.timeAppear
			else
				arg0.timeAppear = arg0.timeAppear - Time.deltaTime
			end

			for iter1 = #arg0._activeFurnitures, 1, -1 do
				local var4 = arg0._activeFurnitures[iter1]

				if var4.time then
					var4.time = var4.time - Time.deltaTime

					if var4.time <= 0 then
						arg0:setFurnitureTimeEvent(var4)
					end
				end
			end

			if var0 then
				arg0:appearChar()
			end
		end,
		setFurnitureTimeEvent = function(arg0, arg1)
			if arg1.data.type == var15 then
				arg0:returnCharIndex(arg1.charIndex)

				if math.random() <= arg1.data.weight and #var46 > 0 then
					arg1.charIndex = table.remove(var46, math.random(1, #var46))
				else
					arg1.charIndex = arg1.data.defaut_char_index
				end

				arg1.readyToRemove = false
				arg1.time = arg1.data.time

				GetComponent(findTF(arg1.animTf, "anim"), typeof(Animator)):SetInteger("charIndex", arg1.charIndex)
			elseif arg1.data.type == var13 then
				if arg1.data.hide and not arg1.readyToRemove then
					arg1.time = 2
					arg1.readyToRemove = true

					local var0 = findTF(arg1.animTf, "anim")

					GetComponent(var0, typeof(Animator)):SetTrigger("hide")
				else
					arg0:returnFurniture(arg1)
				end
			elseif arg1.data.type == var14 then
				if arg1.charIndex then
					arg0:returnCharIndex(arg1.charIndex)

					if arg1.animTf then
						setActive(findTF(arg1.animTf, "collider"), false)
					end

					arg1.charIndex = nil
					arg1.time = nil
				end
			else
				arg0:returnFurniture(arg1)
			end
		end,
		returnCharIndex = function(arg0, arg1)
			if not table.contains(var46, arg1) and table.contains(var38, arg1) then
				table.insert(var46, arg1)
			end
		end,
		appearChar = function(arg0, arg1)
			if #var46 <= 0 then
				return
			end

			if #arg0._furnituresPools <= 0 then
				return
			end

			local var0

			if arg1 then
				var0 = arg0:getFunitureFromPool(arg1)
			end

			var0 = var0 or table.remove(arg0._furnituresPools, math.random(1, #arg0._furnituresPools))

			local var1 = var0.data
			local var2 = var1.pos_data_list[math.random(1, #var1.pos_data_list)]
			local var3 = var2.pos_name
			local var4 = var2.anim_name
			local var5 = arg0:getActiveIndex()
			local var6 = var40[var4]

			if not var6 then
				print("警告，没有找到" .. var4 .. "的动画数据")
				arg0:returnFurniture(var0)

				return
			end

			local var7

			if var0.data.type == var15 then
				var7 = var0.data.defaut_char_index
			else
				var7 = table.remove(var46, math.random(1, #var46))
			end

			var0.charIndex = var7

			if table.contains(var6.ignore_char, var7) then
				arg0:returnFurniture(var0)

				return
			elseif var0.data.type == var14 and var0.initFlag then
				arg0:returnFurniture(var0)

				return
			end

			var0.posData = var2
			var0.activeIndex = var5
			var0.animData = var6

			table.insert(arg0._activeFurnitures, var0)
			arg0:getAnimTfByPosData(var2, var5, function(arg0, arg1)
				if arg1 ~= var0.activeIndex then
					arg0:returnAnimTf(var4, arg0)

					return
				end

				if var0.data.hide_tfs then
					for iter0 = 1, #var0.data.hide_tfs do
						setActive(findTF(var0.tf, var0.data.hide_tfs[iter0]), false)
					end
				end

				local var0 = findTF(var0.tf, var3)

				SetParent(arg0, var0)
				setActive(arg0, true)
				setActive(findTF(arg0, "collider"), true)

				arg0.anchoredPosition = Vector2(0, 0)
				var0.animTf = arg0

				arg0:prepareAnim(var0)
			end)
		end,
		getFunitureFromPool = function(arg0, arg1)
			for iter0 = 1, #arg0._furnituresPools do
				if arg0._furnituresPools[iter0].data.name == arg1 then
					return table.remove(arg0._furnituresPools, iter0)
				end
			end

			return nil
		end,
		prepareAnim = function(arg0, arg1)
			if not arg1.animData or not arg1.animTf then
				return
			end

			local var0 = arg1.animData
			local var1 = arg1.animTf

			arg1.time = arg1.data.time

			local var2 = GetComponent(findTF(var1, "anim"), typeof(Animator))

			var2:SetInteger("charIndex", arg1.charIndex)

			if arg1.data.type ~= var15 then
				var2:SetTrigger("trigger")
			end

			GetOrAddComponent(findTF(var1, "collider"), typeof(EventTriggerListener)):AddPointDownFunc(function(arg0, arg1, arg2)
				if arg1.readyToRemove then
					return
				end

				if arg1.data.type == var15 and arg1.data.defaut_char_index == arg1.charIndex and not arg1.data.defaut_trigger then
					return
				end

				local var0 = false

				if arg1.data.type == var15 and arg1.data.defaut_char_index == arg1.charIndex then
					var0 = true
				end

				if not var0 then
					local var1 = arg0:getScore()

					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3)
					arg0._event:emit(var12, {
						score = var1,
						pos = arg1.position
					})
				end

				arg1.readyToRemove = true

				var2:SetTrigger("next")

				arg1.time = arg1.data.time or 3
			end)
		end,
		getScore = function(arg0)
			if not arg0.additiveScore then
				arg0.additiveScore = var7
			end

			if arg0.scoreTime and arg0.timeStep - arg0.scoreTime < var8 then
				arg0.additiveScore = arg0.additiveScore + var9
			else
				arg0.additiveScore = var7
			end

			if arg0.additiveScore >= var10 then
				arg0.additiveScore = var10
			end

			arg0.scoreTime = arg0.timeStep

			return arg0.additiveScore
		end,
		getAnimTfByPosData = function(arg0, arg1, arg2, arg3)
			local var0 = arg1.anim_name

			if arg0._furnitureAnimTfPool and arg0._furnitureAnimTfPool[var0] and #arg0._furnitureAnimTfPool[var0] > 0 then
				arg3(table.remove(arg0._furnitureAnimTfPool[var0], 1), arg2)

				return
			end

			return arg0:createAnimTf(var0, arg2, arg3)
		end,
		returnFurniture = function(arg0, arg1)
			if not arg1 then
				return
			end

			if arg1.charIndex then
				arg0:returnCharIndex(arg1.charIndex)

				arg1.charIndex = nil
			end

			if arg1.animData and arg1.animTf then
				local var0 = arg1.animData.name

				arg0:returnAnimTf(var0, arg1.animTf)
			end

			if arg1.data.hide_tfs then
				for iter0 = 1, #arg1.data.hide_tfs do
					setActive(findTF(arg1.tf, arg1.data.hide_tfs[iter0]), true)
				end
			end

			arg1.animTf = nil
			arg1.animData = nil
			arg1.activeIndex = nil
			arg1.readyToRemove = false
			arg1.time = nil

			for iter1 = #arg0._activeFurnitures, 1, -1 do
				if arg0._activeFurnitures[iter1] == arg1 then
					table.insert(arg0._furnituresPools, table.remove(arg0._activeFurnitures, iter1))
				end
			end

			for iter2 = #arg0._unActiveFurnitures, 1, -1 do
				if arg0._unActiveFurnitures[iter2] == arg1 then
					table.insert(arg0._furnituresPools, table.remove(arg0._unActiveFurnitures, iter2))
				end
			end

			local var1 = false

			for iter3 = 1, #arg0._furnituresPools do
				if arg0._furnituresPools[iter3] == arg1 then
					var1 = true
				end
			end

			if not var1 then
				table.insert(arg0._furnituresPools, arg1)
			end
		end,
		returnAnimTf = function(arg0, arg1, arg2)
			if not arg0._furnitureAnimTfPool[arg1] then
				arg0._furnitureAnimTfPool[arg1] = {}
			end

			setActive(arg2, false)
			table.insert(arg0._furnitureAnimTfPool[arg1], arg2)
		end,
		createAnimTf = function(arg0, arg1, arg2, arg3)
			local var0 = var40[arg1]

			if not var0 then
				return nil
			end

			local var1 = var0.prefab
			local var2 = var0.name

			if arg0._animTplDic[var2] then
				arg3(tf(Instantiate(arg0._animTplDic[var2])), arg2)
			else
				LoadAndInstantiateAsync(var36, var1, function(arg0)
					if not arg0 then
						print("找不到资源" .. var2)

						return
					end

					if arg0.destroyFlag then
						Destroy(arg0)

						return
					end

					arg0._animTplDic[var2] = arg0

					SetParent(tf(arg0), arg0._tplContainer)
					arg3(tf(Instantiate(arg0._animTplDic[var2])), arg2)
				end)
			end
		end,
		getActiveIndex = function(arg0)
			if not arg0._activeIndex then
				arg0._activeIndex = 0
			end

			arg0._activeIndex = arg0._activeIndex + 1

			return arg0._activeIndex
		end,
		clear = function(arg0)
			for iter0 = #arg0._activeFurnitures, 1, -1 do
				arg0:returnFurniture(arg0._activeFurnitures[iter0])
			end

			for iter1 = #arg0._unActiveFurnitures, 1, -1 do
				arg0:returnFurniture(arg0._unActiveFurnitures[iter1])
			end

			for iter2 = 1, #arg0._furnituresPools do
				local var0 = arg0._furnituresPools[iter2]

				if var0.data.type == var14 then
					var0.initFlag = false
				end
			end

			arg0._activeFurnitures = {}
			var46 = Clone(var38)
		end,
		destroy = function(arg0)
			arg0:clear()

			for iter0 = 1, #arg0._furnitureAnimTfPool do
				local var0 = arg0._furnitureAnimTfPool[iter0].animTf

				if var0 then
					local var1 = GetOrAddComponent(findTF(var0, "collider"), typeof(EventTriggerListener))

					ClearEventTrigger(var1)
				end
			end

			arg0.destroyFlag = true
		end
	}

	var0:ctor()

	return var0
end

local var48 = {
	{
		start = true,
		name = "posMoveRole_1",
		switch_parent = true,
		finish = true,
		finish_weight = 1,
		next = {
			"posMoveRole_2"
		}
	},
	{
		finish = false,
		name = "posMoveRole_2",
		start = false,
		next = {
			"posMoveRole_1",
			"posMoveRole_3",
			"posMoveRole_4"
		}
	},
	{
		finish = false,
		name = "posMoveRole_3",
		start = false,
		finish_weight = 1,
		next = {
			"posMoveRole_2",
			"posMoveRole_5"
		}
	},
	{
		finish = true,
		name = "posMoveRole_4",
		start = true,
		finish_weight = 1,
		next = {
			"posMoveRole_2"
		}
	},
	{
		finish = false,
		name = "posMoveRole_5",
		start = false,
		finish_weight = 1,
		next = {
			"posMoveRole_3",
			"posMoveRole_6",
			"posMoveRole_9"
		}
	},
	{
		finish = false,
		name = "posMoveRole_6",
		start = false,
		finish_weight = 1,
		next = {
			"posMoveRole_5",
			"posMoveRole_7",
			"posMoveRole_8"
		}
	},
	{
		start = true,
		name = "posMoveRole_7",
		switch_parent = true,
		finish = true,
		finish_weight = 1,
		next = {
			"posMoveRole_6"
		}
	},
	{
		finish = true,
		name = "posMoveRole_8",
		start = true,
		finish_weight = 1,
		next = {
			"posMoveRole_6"
		}
	},
	{
		finish = true,
		name = "posMoveRole_9",
		start = true,
		finish_weight = 1,
		next = {
			"posMoveRole_5"
		}
	}
}
local var49 = {
	5,
	10
}
local var50 = 300
local var51 = 200

local function var52(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
			arg0._roleTf = findTF(arg0._tf, "fushun")
			arg0._roleAnimator = GetComponent(findTF(arg0._roleTf, "img/anim"), typeof(Animator))
			arg0._dftEvent = GetComponent(findTF(arg0._roleTf, "img/anim"), typeof(DftAniEvent))

			arg0._dftEvent:SetEndEvent(function(arg0)
				setActive(arg0._roleTf, false)
				arg0:clear()
			end)

			arg0._eventTrigger = GetOrAddComponent(findTF(arg0._roleTf, "img/collider"), typeof(EventTriggerListener))

			arg0._eventTrigger:AddPointDownFunc(function(arg0, arg1, arg2)
				if arg0.removeRoleFlag then
					return
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3)
				arg0._event:emit(var12, {
					score = var11,
					pos = arg1.position
				})

				arg0.removeRoleFlag = true

				arg0:setRoleAnimatorTrigger("touch")
			end)

			arg0._roleShowData = {}
			arg0._roleShowStartData = {}

			for iter0 = 1, #var48 do
				if var48[iter0].start then
					table.insert(arg0._roleShowStartData, Clone(var48[iter0]))
				end

				local var0 = Clone(var48[iter0])

				arg0._roleShowData[var0.name] = var0
			end

			arg0._active = false
			arg0._targetPos = Vector2(0, 0)
			arg0._currentTargetData = nil
			arg0._currentTargetPos = nil
		end,
		setRoleAnimatorTrigger = function(arg0, arg1, arg2)
			if not arg2 then
				arg0._roleAnimator:SetTrigger(arg1)
			else
				arg0._roleAnimator:ResetTrigger(arg1)
			end
		end,
		start = function(arg0)
			arg0.showTime = math.random() * (var49[2] - var49[1]) + var49[1]

			arg0:clear()
		end,
		step = function(arg0)
			if arg0.showTime > 0 then
				arg0.showTime = arg0.showTime - Time.deltaTime

				if arg0.showTime <= 0 then
					arg0.showTime = 0

					arg0:checkShow()
				end
			end

			if arg0._currentTargetData and not arg0.removeRoleFlag then
				local var0 = arg0._roleTf.anchoredPosition
				local var1 = var50 * math.cos(arg0._moveAngle) * Time.deltaTime
				local var2 = var50 * math.sin(arg0._moveAngle) * Time.deltaTime

				if arg0._roleDirectX == 1 and arg0._roleDirectX * var1 + var0.x > arg0._currentTargetPos.x then
					var0.x = var0.x + arg0._roleDirectX * var1
					arg0._roleDirectX = nil
				elseif arg0._roleDirectX == -1 and arg0._roleDirectX * var1 + var0.x < arg0._currentTargetPos.x then
					var0.x = var0.x + arg0._roleDirectX * var1
					arg0._roleDirectX = nil
				elseif arg0._roleDirectX then
					var0.x = var0.x + arg0._roleDirectX * var1
				end

				if arg0._roleDirectY == 1 and arg0._roleDirectY * var2 + var0.y > arg0._currentTargetPos.y then
					var0.y = var0.y + arg0._roleDirectY * var2
					arg0._roleDirectY = nil
				elseif arg0._roleDirectY == -1 and arg0._roleDirectY * var2 + var0.y < arg0._currentTargetPos.y then
					var0.y = var0.y + arg0._roleDirectY * var2
					arg0._roleDirectY = nil
				elseif arg0._roleDirectY then
					var0.y = var0.y + arg0._roleDirectY * var2
				end

				arg0._roleTf.anchoredPosition = var0

				if arg0._roleDirectX == nil and arg0._roleDirectY == nil then
					arg0:setRoleNext()
				end
			end
		end,
		setRoleStatus = function(arg0, arg1)
			setActive(arg0._roleTf, true)

			if arg1 then
				arg0:setRoleAnimatorTrigger("change", true)
				arg0:setRoleAnimatorTrigger("hide", true)
				arg0:setRoleAnimatorTrigger("show")
			else
				arg0:setRoleAnimatorTrigger("change")
			end

			arg0._roleAnimator:SetInteger("directX", arg0._roleDirectX)
			arg0._roleAnimator:SetInteger("directY", arg0._roleDirectY)
		end,
		setRoleNext = function(arg0, arg1)
			if arg1 or not arg0._currentTargetData.finish then
				local var0

				if not arg1 then
					var0 = arg0._currentData.name
					var0 = arg0._currentData.name
					arg0._currentData = arg0._currentTargetData
				end

				local var1 = Clone(arg0._currentData.next)

				if var0 then
					for iter0 = #var1, 1, -1 do
						if var1[iter0] == var0 then
							table.remove(var1, iter0)
						end
					end
				end

				if #var1 == 0 then
					arg0:clear()

					return
				end

				local var2 = var1[math.random(1, #var1)]

				arg0._currentTargetData = arg0._roleShowData[var2]

				local var3 = findTF(arg0._tf, arg0._currentData.name)
				local var4 = findTF(arg0._tf, arg0._currentTargetData.name)

				if arg0._currentTargetData and arg0._currentTargetData.switch_parent then
					setParent(arg0._roleTf, var4)
				else
					setParent(arg0._roleTf, var3)
				end

				local var5 = findTF(var3, "rolePos")

				arg0._roleTf.anchoredPosition = var5.anchoredPosition
				arg0._currentTargetPos = findTF(arg0._tf, arg0._currentTargetData.name .. "/rolePos").anchoredPosition
				arg0._roleDirectX = arg0._currentTargetPos.x > arg0._roleTf.anchoredPosition.x and 1 or -1
				arg0._roleDirectY = arg0._currentTargetPos.y > arg0._roleTf.anchoredPosition.y and 1 or -1
				arg0._moveAngle = math.atan(math.abs(arg0._currentTargetPos.y - arg0._roleTf.anchoredPosition.y) / math.abs(arg0._currentTargetPos.x - arg0._roleTf.anchoredPosition.x))
				arg0.removeRoleFlag = false

				arg0:setRoleStatus(arg1)
			elseif arg0._currentTargetData.finish then
				arg0:clear()
			end
		end,
		checkShow = function(arg0)
			if arg0._active and not table.contains(var46, var37) then
				return
			end

			for iter0 = #var46, 1, -1 do
				if var46[iter0] == var37 then
					table.remove(var46, iter0)
				end
			end

			arg0._active = true
			arg0._currentData = arg0._roleShowStartData[math.random(1, #arg0._roleShowStartData)]

			arg0:setRoleNext(true)
		end,
		clear = function(arg0)
			arg0._currentTargetData = nil
			arg0._currentTargetPos = nil

			if not table.contains(var46, var37) then
				table.insert(var46, var37)
			end

			if isActive(arg0._roleTf) then
				arg0:setRoleAnimatorTrigger("hide")

				arg0.removeRoleFlag = true

				setActive(arg0._roleTf, false)
			end

			arg0.showTime = math.random() * (var49[2] - var49[1]) + var49[1]
			arg0._active = false
		end,
		destroy = function(arg0)
			return
		end
	}

	var0:ctor()

	return var0
end

local var53 = {
	"boot00",
	"boot01",
	"boot02"
}
local var54 = {
	"game00",
	"game01",
	"game02"
}
local var55 = {
	"tv00",
	"tv01",
	"tv02",
	"tv03",
	"tv04",
	"tv05",
	"tv06",
	"tv07",
	"tv08",
	"tv09",
	"tv10",
	"tv11",
	"tv12",
	"tv13",
	"tv14"
}
local var56 = {
	1,
	3
}

local function var57(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
			arg0.loadedFlag = false
			arg0._tvTf = nil
			arg0._active = false
			arg0._tvAnimator = nil

			onButton(arg0._event, findTF(arg0._tf, "collider"), function()
				if arg0.loadedFlag then
					return
				end

				arg0._active = not arg0._active

				arg0:updateUI()
			end, SFX_CANCEL)
		end,
		start = function(arg0)
			arg0._active = true

			arg0:updateUI()

			if not arg0.loadedFlag then
				LoadAndInstantiateAsync(var36, var45, function(arg0)
					if not arg0 then
						print("tv资源加载失败")

						return
					end

					if arg0.destroyFlag then
						Destroy(arg0)

						return
					end

					arg0.loadedFlag = true
					arg0._tvTf = tf(arg0)
					arg0._tvAnimator = GetComponent(findTF(arg0._tvTf, "anim"), typeof(Animator))

					GetComponent(findTF(arg0._tvTf, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
						arg0:onTvComplete()
					end)
					onButton(arg0._event, findTF(arg0._tvTf, "collider"), function()
						arg0._active = not arg0._active

						arg0:updateUI()
					end)
					setParent(arg0._tvTf, findTF(arg0._tf, "posTv"))
					arg0:updateUI()
					arg0:setTvData()
				end)
			else
				arg0:setTvData()
			end
		end,
		setTvData = function(arg0)
			arg0.playIndex = 1
			arg0.playTvData = {}

			local var0 = math.random(var56[1], var56[2])
			local var1 = Clone(var55)
			local var2 = Clone(var53)
			local var3 = Clone(var54)

			for iter0 = 1, var0 do
				table.insert(arg0.playTvData, table.remove(var1, math.random(1, #var1)))
			end

			table.insert(arg0.playTvData, table.remove(var2, math.random(1, #var2)))
			table.insert(arg0.playTvData, table.remove(var3, math.random(1, #var3)))
			arg0._tvAnimator:Play(arg0.playTvData[arg0.playIndex], -1, 0)
		end,
		onTvComplete = function(arg0)
			if not arg0.playIndex and not arg0.playTvData and #arg0.playTvData == 0 then
				return
			end

			if arg0._tvAnimator then
				arg0.playIndex = arg0.playIndex + 1

				if arg0.playIndex > #arg0.playTvData then
					arg0.playIndex = #arg0.playTvData
				end

				arg0._tvAnimator:Play(arg0.playTvData[arg0.playIndex], -1, 0)
			end
		end,
		step = function(arg0)
			if arg0._tvAnimator and arg0._tvAnimator.speed == 0 then
				arg0._tvAnimator.speed = 1
			end
		end,
		pause = function(arg0)
			if arg0._tvAnimator then
				arg0._tvAnimator.speed = 0
			end
		end,
		updateUI = function(arg0)
			if arg0.loadedFlag then
				setActive(findTF(arg0._tf, "on"), false)
				setActive(findTF(arg0._tf, "off"), false)

				if not arg0.tvCanvas then
					arg0.tvCanvas = GetComponent(findTF(arg0._tvTf, "anim"), typeof(CanvasGroup))
				end

				arg0.tvCanvas.alpha = arg0._active and 1 or 0
			else
				setActive(findTF(arg0._tf, "on"), arg0._active)
				setActive(findTF(arg0._tf, "off"), not arg0._active)
			end
		end,
		destroy = function(arg0)
			arg0.destroyFlag = true
		end,
		clear = function(arg0)
			return
		end
	}

	var0:ctor()

	return var0
end

function var0.getUIName(arg0)
	return "HideSeekGameUI"
end

function var0.getBGM(arg0)
	return var1
end

function var0.didEnter(arg0)
	arg0:initEvent()
	arg0:initData()
	arg0:initUI()
	arg0:initGameUI()
	arg0:initController()
	arg0:updateMenuUI()
	arg0:openMenuUI()
end

function var0.initEvent(arg0)
	if not arg0.uiCam then
		arg0.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	end

	arg0:bind(var12, function(arg0, arg1, arg2)
		arg0:addScore(arg1.score)
		arg0:showScore(arg1)
	end)
end

function var0.showScore(arg0, arg1)
	local var0

	if #arg0.showScoresPool > 0 then
		var0 = table.remove(arg0.showScoresPool, 1)
	else
		var0 = tf(Instantiate(arg0.showScoreTpl))

		setParent(var0, arg0.sceneFrontContainer)
		GetComponent(findTF(var0, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
			for iter0 = #arg0.showScores, 1, -1 do
				if var0 == arg0.showScores[iter0] then
					table.insert(arg0.showScoresPool, table.remove(arg0.showScores, iter0))
				end
			end
		end)
	end

	setText(findTF(var0, "anim"), "+" .. tostring(arg1.score))

	local var1 = arg0.uiCam:ScreenToWorldPoint(arg1.pos)

	var0.anchoredPosition = arg0.sceneFrontContainer:InverseTransformPoint(var1)

	setActive(var0, false)
	setActive(var0, true)
	table.insert(arg0.showScores, var0)
end

function var0.onEventHandle(arg0, arg1)
	return
end

function var0.initData(arg0)
	local var0 = Application.targetFrameRate or 60

	if var0 > 60 then
		var0 = 60
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var0, -1)
	arg0.showScores = {}
	arg0.showScoresPool = {}
end

function var0.initUI(arg0)
	arg0.backSceneTf = findTF(arg0._tf, "scene_background")
	arg0.sceneContainer = findTF(arg0._tf, "sceneMask/sceneContainer")
	arg0.sceneFrontContainer = findTF(arg0._tf, "sceneMask/sceneContainer/scene_front")
	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.bg = findTF(arg0._tf, "bg")
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

	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	onButton(arg0, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	onButton(arg0, findTF(arg0.pauseUI, "ad/btnOk"), function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	onButton(arg0, findTF(arg0.settlementUI, "ad/btnOver"), function()
		setActive(arg0.settlementUI, false)
		arg0:openMenuUI()
	end, SFX_CANCEL)

	arg0.menuUI = findTF(arg0._tf, "pop/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
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
			helps = pg.gametip.five_duomaomao.tip
		})
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnStart"), function()
		setActive(arg0.menuUI, false)
		arg0:readyStart()
	end, SFX_CANCEL)

	local var1 = findTF(arg0.menuUI, "tplBattleItem")

	arg0.battleItems = {}

	for iter0 = 1, 7 do
		local var2 = tf(instantiate(var1))

		var2.name = "battleItem_" .. iter0

		setParent(var2, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var3 = iter0

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var4, "battleDesc" .. var3, function(arg0)
			setImageSprite(findTF(var2, "state_open/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_clear/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_current/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_closed/buttomDesc"), arg0, true)
		end)
		setActive(var2, true)
		table.insert(arg0.battleItems, var2)
	end

	if not arg0.handle and IsUnityEditor then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)

		UpdateBeat:AddListener(arg0.handle)
	end
end

function var0.initGameUI(arg0)
	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")
	arg0.showScoreTpl = findTF(arg0.sceneFrontContainer, "score")

	setActive(arg0.showScoreTpl, false)
	onButton(arg0, findTF(arg0.gameUI, "topRight/btnStop"), function()
		arg0:stopGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnLeave"), function()
		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end)

	arg0.gameTimeS = findTF(arg0.gameUI, "top/time/s")
	arg0.scoreTf = findTF(arg0.gameUI, "top/score")
	arg0.sceneContainer.anchoredPosition = Vector2(0, 0)

	local var0 = GetOrAddComponent(arg0.sceneContainer, typeof(EventTriggerListener))
	local var1
	local var2

	arg0.velocityXSmoothing = Vector2(0, 0)
	arg0.offsetPosition = arg0.sceneContainer.anchoredPosition

	var0:AddBeginDragFunc(function(arg0, arg1)
		var1 = arg1.position
		var2 = arg0.sceneContainer.anchoredPosition
		arg0.velocityXSmoothing = Vector2(0, 0)
		arg0.offsetPosition = arg0.sceneContainer.anchoredPosition
	end)
	var0:AddDragFunc(function(arg0, arg1)
		arg0.offsetPosition.x = arg1.position.x - var1.x + var2.x
		arg0.offsetPosition.y = arg1.position.y - var1.y + var2.y
		arg0.offsetPosition.x = arg0.offsetPosition.x > var42[2] and var42[2] or arg0.offsetPosition.x
		arg0.offsetPosition.x = arg0.offsetPosition.x < var42[1] and var42[1] or arg0.offsetPosition.x
		arg0.offsetPosition.y = arg0.offsetPosition.y > var43[2] and var43[2] or arg0.offsetPosition.y
		arg0.offsetPosition.y = arg0.offsetPosition.y < var43[1] and var43[1] or arg0.offsetPosition.y
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		return
	end)
end

function var0.initController(arg0)
	arg0.furnitureCtrl = var47(findTF(arg0.sceneContainer, "scene"), arg0)
	arg0.moveRoleCtrl = var52(findTF(arg0.sceneContainer, "scene"), arg0)
	arg0.tvCtrl = var57(findTF(arg0.sceneContainer, "scene/furniture_tv"), arg0)
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.S) then
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
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0.battleItems[iter0], "state_current"), true)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			setActive(findTF(arg0.battleItems[iter0], "state_open"), true)
		else
			setActive(findTF(arg0.battleItems[iter0], "state_closed"), true)
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
	setActive(findTF(arg0.sceneContainer, "scene_front"), false)
	setActive(findTF(arg0.sceneContainer, "scene_background"), false)
	setActive(findTF(arg0.sceneContainer, "scene"), false)
	setActive(arg0.gameUI, false)
	setActive(arg0.menuUI, true)
	setActive(arg0.bg, true)
	arg0:updateMenuUI()
end

function var0.clearUI(arg0)
	setActive(arg0.sceneContainer, false)
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

function var0.gameStart(arg0)
	setActive(findTF(arg0.sceneContainer, "scene_front"), true)
	setActive(findTF(arg0.sceneContainer, "scene_background"), true)
	setActive(findTF(arg0.sceneContainer, "scene"), true)
	setActive(arg0.bg, false)

	arg0.sceneContainer.anchoredPosition = var44
	arg0.offsetPosition = var44

	setActive(arg0.gameUI, true)

	arg0.gameStartFlag = true
	arg0.scoreNum = 0
	arg0.nextPositionIndex = 2
	arg0.gameStepTime = 0
	arg0.heart = 3
	arg0.gameTime = var5

	for iter0 = #arg0.showScores, 1, -1 do
		if not table.contains(arg0.showScoresPool, arg0.showScores[iter0]) then
			local var0 = table.remove(arg0.showScores, iter0)

			table.insert(arg0.showScoresPool, var0)
		end
	end

	for iter1 = #arg0.showScoresPool, 1, -1 do
		setActive(arg0.showScoresPool[iter1], false)
	end

	arg0:updateGameUI()
	arg0:timerStart()
	arg0:controllerStart()
end

function var0.controllerStart(arg0)
	if arg0.furnitureCtrl then
		arg0.furnitureCtrl:start()
	end

	if arg0.moveRoleCtrl then
		arg0.moveRoleCtrl:start()
	end

	if arg0.tvCtrl then
		arg0.tvCtrl:start()
	end
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

function var0.changeSpeed(arg0, arg1)
	return
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	arg0.gameTime = arg0.gameTime - Time.deltaTime

	if arg0.gameTime < 0 then
		arg0.gameTime = 0
	end

	arg0.gameStepTime = arg0.gameStepTime + Time.deltaTime

	arg0:controllerStep()
	arg0:updateGameUI()

	if arg0.gameTime <= 0 then
		arg0:onGameOver()

		return
	end
end

function var0.controllerStep(arg0)
	if arg0.furnitureCtrl then
		arg0.furnitureCtrl:step()
	end

	if arg0.moveRoleCtrl then
		arg0.moveRoleCtrl:step()
	end

	if arg0.tvCtrl then
		arg0.tvCtrl:step()
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

		if arg0.tvCtrl then
			arg0.tvCtrl:pause()
		end
	end
end

function var0.updateGameUI(arg0)
	setText(arg0.scoreTf, arg0.scoreNum)
	setText(arg0.gameTimeS, math.ceil(arg0.gameTime))

	arg0.sceneContainer.anchoredPosition, arg0.velocityXSmoothing = Vector2.SmoothDamp(arg0.sceneContainer.anchoredPosition, arg0.offsetPosition, arg0.velocityXSmoothing, var41)
end

function var0.addScore(arg0, arg1)
	arg0.scoreNum = arg0.scoreNum + arg1

	if arg0.scoreNum < 0 then
		arg0.scoreNum = 0
	end
end

function var0.onGameOver(arg0)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()

	arg0.settlementFlag = true

	setActive(arg0.clickMask, true)
	LeanTween.delayedCall(go(arg0._tf), 0.1, System.Action(function()
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
	arg0:changeSpeed(1)
	arg0:timerStart()
end

function var0.stopGame(arg0)
	arg0.gameStop = true

	arg0:timerStop()
	arg0:changeSpeed(0)
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

	arg0:destroyController()

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	Time.timeScale = 1
	arg0.timer = nil
end

function var0.destroyController(arg0)
	if arg0.furnitureCtrl then
		arg0.furnitureCtrl:destroy()
	end

	if arg0.moveRoleCtrl then
		arg0.moveRoleCtrl:destroy()
	end

	if arg0.tvCtrl then
		arg0.tvCtrl:destroy()
	end
end

return var0
