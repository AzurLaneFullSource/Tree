local var0_0 = class("HideSeekGameView", import("..BaseMiniGameView"))
local var1_0 = "bar-soft"
local var2_0 = "event:/ui/ddldaoshu2"
local var3_0 = "event:/ui/break_out_full"
local var4_0 = "hideseekgameui_atlas"
local var5_0 = 60
local var6_0 = {
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
local var7_0 = 100
local var8_0 = 2
local var9_0 = 50
local var10_0 = 400
local var11_0 = 400
local var12_0 = "on_touch_furniture"
local var13_0 = 1
local var14_0 = 2
local var15_0 = 3
local var16_0 = 4
local var17_0 = "HideSeekBath"
local var18_0 = "HideSeekBed"
local var19_0 = "HideSeekFridge"
local var20_0 = "HideSeekHakoCL"
local var21_0 = "HideSeekHakoCR"
local var22_0 = "HideSeekUpR"
local var23_0 = "HideSeekUpL"
local var24_0 = "HideSeekDeskUnder"
local var25_0 = "HideSeekSofaS"
local var26_0 = "HideSeekSofaL"
local var27_0 = "HideSeekHakoSL"
local var28_0 = "HideSeekHakoSR"
local var29_0 = "HideSeekHakoML"
local var30_0 = "HideSeekHakoMR"
local var31_0 = "HideSeekDeskSR"
local var32_0 = "HideSeekDeskSL"
local var33_0 = "HideSeekDeskStudyL"
local var34_0 = "HideSeekDeskStudyR"
local var35_0 = "HideSeekCushion"
local var36_0 = "ui/minigameui/hideseek"
local var37_0 = 3
local var38_0 = {
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
local var39_0 = {
	{
		name = "furniture_bath",
		pos_data_list = {
			{
				pos_name = "posBath",
				anim_name = var17_0
			}
		},
		type = var13_0
	},
	{
		weight = 0.2,
		name = "furniture_bed",
		pos_data_list = {
			{
				pos_name = "posBed",
				anim_name = var18_0
			}
		},
		type = var14_0
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
				anim_name = var19_0
			}
		},
		type = var15_0
	},
	{
		time = 4,
		name = "furniture_Hako_L1",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoCL",
				anim_name = var20_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Cook",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posUpR",
				anim_name = var22_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Desk_Dining",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posUnder",
				anim_name = var24_0
			},
			{
				pos_name = "posUpR",
				anim_name = var22_0
			},
			{
				pos_name = "posUpL",
				anim_name = var23_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Sofa_S",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posSofaS",
				anim_name = var25_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Sofa_L",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posSofaL",
				anim_name = var26_0
			},
			{
				pos_name = "posUpL",
				anim_name = var23_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Hako_S1_3",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoSL",
				anim_name = var27_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Desk_S",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posDeskSL",
				anim_name = var32_0
			},
			{
				pos_name = "posDeskSR",
				anim_name = var31_0
			},
			{
				pos_name = "posDeskUnder",
				anim_name = var24_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Hako_L2",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoCL",
				anim_name = var20_0
			},
			{
				pos_name = "posHakoCR",
				anim_name = var21_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Desk_Study",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posDeskStudyL",
				anim_name = var33_0
			},
			{
				pos_name = "posDeskStudyR",
				anim_name = var34_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Hako_M1",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoML",
				anim_name = var29_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Hako_M2",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoMR",
				anim_name = var30_0
			}
		},
		type = var13_0
	},
	{
		time = 4,
		name = "furniture_Hako_S2",
		hide = true,
		pos_data_list = {
			{
				pos_name = "posHakoSR",
				anim_name = var28_0
			}
		},
		type = var13_0
	},
	{
		name = "furniture_Manjuu_cushion",
		pos_data_list = {
			{
				pos_name = "posCushion",
				anim_name = var35_0
			}
		},
		type = var13_0,
		hide_tfs = {
			"img"
		}
	}
}
local var40_0 = {
	HideSeekBath = {
		prefab = "hideseekbath.prefab",
		name = var17_0,
		ignore_char = {}
	},
	HideSeekBed = {
		prefab = "hideseekbed.prefab",
		name = var18_0,
		ignore_char = {}
	},
	HideSeekFridge = {
		prefab = "hideseekfridge.prefab",
		name = var19_0,
		ignore_char = {}
	},
	HideSeekHakoCL = {
		prefab = "hideseekhakocl.prefab",
		name = var20_0,
		ignore_char = {}
	},
	HideSeekHakoCR = {
		prefab = "hideseekhakocr.prefab",
		name = var21_0,
		ignore_char = {}
	},
	HideSeekUpR = {
		prefab = "hideseekupr.prefab",
		name = var22_0,
		ignore_char = {}
	},
	HideSeekUpL = {
		prefab = "hideseekupl.prefab",
		name = var23_0,
		ignore_char = {}
	},
	HideSeekDeskUnder = {
		prefab = "hideseekdeskunder.prefab",
		name = var24_0,
		ignore_char = {}
	},
	HideSeekSofaS = {
		prefab = "hideseeksofas.prefab",
		name = var25_0,
		ignore_char = {}
	},
	HideSeekSofaL = {
		prefab = "hideseeksofal.prefab",
		name = var26_0,
		ignore_char = {}
	},
	HideSeekHakoSL = {
		prefab = "hideseekhakosl.prefab",
		name = var27_0,
		ignore_char = {}
	},
	HideSeekHakoSR = {
		prefab = "hideseekhakosr.prefab",
		name = var28_0,
		ignore_char = {}
	},
	HideSeekDeskSL = {
		prefab = "hideseekdesksl.prefab",
		name = var32_0,
		ignore_char = {}
	},
	HideSeekDeskSR = {
		prefab = "hideseekdesksr.prefab",
		name = var31_0,
		ignore_char = {}
	},
	HideSeekDeskStudyL = {
		prefab = "hideseekdeskstudyl.prefab",
		name = var33_0,
		ignore_char = {}
	},
	HideSeekDeskStudyR = {
		prefab = "hideseekdeskstudyr.prefab",
		name = var34_0,
		ignore_char = {}
	},
	HideSeekHakoML = {
		prefab = "hideseekhakoml.prefab",
		name = var29_0,
		ignore_char = {}
	},
	HideSeekHakoMR = {
		prefab = "hideseekhakomr.prefab",
		name = var30_0,
		ignore_char = {}
	},
	HideSeekCushion = {
		prefab = "hideseekcushion.prefab",
		name = var35_0,
		ignore_char = {}
	}
}
local var41_0 = 0.1
local var42_0 = {
	-475,
	652
}
local var43_0 = {
	-335,
	290
}
local var44_0 = Vector2(150, -200)
local var45_0 = "hideseektv.prefab"
local var46_0 = {}

local function var47_0(arg0_1, arg1_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2._event = arg1_1
			arg0_2._sceneTf = arg0_1
			arg0_2._tplContainer = findTF(arg0_1, "tplPos")
			var46_0 = Clone(var38_0)
			arg0_2._furnituresPools = {}

			for iter0_2 = 1, #var39_0 do
				local var0_2 = Clone(var39_0[iter0_2])
				local var1_2 = findTF(arg0_2._sceneTf, var39_0[iter0_2].name)

				table.insert(arg0_2._furnituresPools, {
					activeIndex = 0,
					data = var0_2,
					tf = var1_2
				})
			end

			arg0_2._unActiveFurnitures = {}
			arg0_2._activeFurnitures = {}
			arg0_2._furnitureAnimTfPool = {}
			arg0_2._animTplDic = {}
		end,
		start = function(arg0_3)
			arg0_3.timeStep = 0

			arg0_3:clear()

			arg0_3.timeAppear = 0
			arg0_3.additiveScore = var7_0

			for iter0_3 = #arg0_3._furnituresPools, 1, -1 do
				local var0_3 = arg0_3._furnituresPools[iter0_3]

				if var0_3.data.type == var14_0 then
					if math.random() <= var0_3.data.weight then
						arg0_3:appearChar(var0_3.data.name)
					end

					var0_3.initFlag = true

					table.insert(arg0_3._unActiveFurnitures, arg0_3:getFunitureFromPool(var0_3.data.name))
				elseif var0_3.data.type == var15_0 then
					arg0_3:appearChar(var0_3.data.name)
				end
			end
		end,
		step = function(arg0_4)
			arg0_4.timeStep = arg0_4.timeStep + Time.deltaTime

			local var0_4 = false

			if arg0_4.timeAppear <= 0 then
				var0_4 = true

				local var1_4 = var5_0 - arg0_4.timeStep

				arg0_4.timeAppear = nil

				for iter0_4 = 1, #var6_0 do
					if not arg0_4.timeAppear and var1_4 < var6_0[iter0_4][1] or iter0_4 == #var6_0 then
						local var2_4 = var6_0[iter0_4][2]
						local var3_4 = var6_0[iter0_4][3]

						arg0_4.timeAppear = math.random() * (var3_4 - var2_4) + var2_4

						break
					end
				end

				arg0_4.timeAppear = not arg0_4.timeAppear and 2 or arg0_4.timeAppear
			else
				arg0_4.timeAppear = arg0_4.timeAppear - Time.deltaTime
			end

			for iter1_4 = #arg0_4._activeFurnitures, 1, -1 do
				local var4_4 = arg0_4._activeFurnitures[iter1_4]

				if var4_4.time then
					var4_4.time = var4_4.time - Time.deltaTime

					if var4_4.time <= 0 then
						arg0_4:setFurnitureTimeEvent(var4_4)
					end
				end
			end

			if var0_4 then
				arg0_4:appearChar()
			end
		end,
		setFurnitureTimeEvent = function(arg0_5, arg1_5)
			if arg1_5.data.type == var15_0 then
				arg0_5:returnCharIndex(arg1_5.charIndex)

				if math.random() <= arg1_5.data.weight and #var46_0 > 0 then
					arg1_5.charIndex = table.remove(var46_0, math.random(1, #var46_0))
				else
					arg1_5.charIndex = arg1_5.data.defaut_char_index
				end

				arg1_5.readyToRemove = false
				arg1_5.time = arg1_5.data.time

				GetComponent(findTF(arg1_5.animTf, "anim"), typeof(Animator)):SetInteger("charIndex", arg1_5.charIndex)
			elseif arg1_5.data.type == var13_0 then
				if arg1_5.data.hide and not arg1_5.readyToRemove then
					arg1_5.time = 2
					arg1_5.readyToRemove = true

					local var0_5 = findTF(arg1_5.animTf, "anim")

					GetComponent(var0_5, typeof(Animator)):SetTrigger("hide")
				else
					arg0_5:returnFurniture(arg1_5)
				end
			elseif arg1_5.data.type == var14_0 then
				if arg1_5.charIndex then
					arg0_5:returnCharIndex(arg1_5.charIndex)

					if arg1_5.animTf then
						setActive(findTF(arg1_5.animTf, "collider"), false)
					end

					arg1_5.charIndex = nil
					arg1_5.time = nil
				end
			else
				arg0_5:returnFurniture(arg1_5)
			end
		end,
		returnCharIndex = function(arg0_6, arg1_6)
			if not table.contains(var46_0, arg1_6) and table.contains(var38_0, arg1_6) then
				table.insert(var46_0, arg1_6)
			end
		end,
		appearChar = function(arg0_7, arg1_7)
			if #var46_0 <= 0 then
				return
			end

			if #arg0_7._furnituresPools <= 0 then
				return
			end

			local var0_7

			if arg1_7 then
				var0_7 = arg0_7:getFunitureFromPool(arg1_7)
			end

			var0_7 = var0_7 or table.remove(arg0_7._furnituresPools, math.random(1, #arg0_7._furnituresPools))

			local var1_7 = var0_7.data
			local var2_7 = var1_7.pos_data_list[math.random(1, #var1_7.pos_data_list)]
			local var3_7 = var2_7.pos_name
			local var4_7 = var2_7.anim_name
			local var5_7 = arg0_7:getActiveIndex()
			local var6_7 = var40_0[var4_7]

			if not var6_7 then
				print("警告，没有找到" .. var4_7 .. "的动画数据")
				arg0_7:returnFurniture(var0_7)

				return
			end

			local var7_7

			if var0_7.data.type == var15_0 then
				var7_7 = var0_7.data.defaut_char_index
			else
				var7_7 = table.remove(var46_0, math.random(1, #var46_0))
			end

			var0_7.charIndex = var7_7

			if table.contains(var6_7.ignore_char, var7_7) then
				arg0_7:returnFurniture(var0_7)

				return
			elseif var0_7.data.type == var14_0 and var0_7.initFlag then
				arg0_7:returnFurniture(var0_7)

				return
			end

			var0_7.posData = var2_7
			var0_7.activeIndex = var5_7
			var0_7.animData = var6_7

			table.insert(arg0_7._activeFurnitures, var0_7)
			arg0_7:getAnimTfByPosData(var2_7, var5_7, function(arg0_8, arg1_8)
				if arg1_8 ~= var0_7.activeIndex then
					arg0_7:returnAnimTf(var4_7, arg0_8)

					return
				end

				if var0_7.data.hide_tfs then
					for iter0_8 = 1, #var0_7.data.hide_tfs do
						setActive(findTF(var0_7.tf, var0_7.data.hide_tfs[iter0_8]), false)
					end
				end

				local var0_8 = findTF(var0_7.tf, var3_7)

				SetParent(arg0_8, var0_8)
				setActive(arg0_8, true)
				setActive(findTF(arg0_8, "collider"), true)

				arg0_8.anchoredPosition = Vector2(0, 0)
				var0_7.animTf = arg0_8

				arg0_7:prepareAnim(var0_7)
			end)
		end,
		getFunitureFromPool = function(arg0_9, arg1_9)
			for iter0_9 = 1, #arg0_9._furnituresPools do
				if arg0_9._furnituresPools[iter0_9].data.name == arg1_9 then
					return table.remove(arg0_9._furnituresPools, iter0_9)
				end
			end

			return nil
		end,
		prepareAnim = function(arg0_10, arg1_10)
			if not arg1_10.animData or not arg1_10.animTf then
				return
			end

			local var0_10 = arg1_10.animData
			local var1_10 = arg1_10.animTf

			arg1_10.time = arg1_10.data.time

			local var2_10 = GetComponent(findTF(var1_10, "anim"), typeof(Animator))

			var2_10:SetInteger("charIndex", arg1_10.charIndex)

			if arg1_10.data.type ~= var15_0 then
				var2_10:SetTrigger("trigger")
			end

			GetOrAddComponent(findTF(var1_10, "collider"), typeof(EventTriggerListener)):AddPointDownFunc(function(arg0_11, arg1_11, arg2_11)
				if arg1_10.readyToRemove then
					return
				end

				if arg1_10.data.type == var15_0 and arg1_10.data.defaut_char_index == arg1_10.charIndex and not arg1_10.data.defaut_trigger then
					return
				end

				local var0_11 = false

				if arg1_10.data.type == var15_0 and arg1_10.data.defaut_char_index == arg1_10.charIndex then
					var0_11 = true
				end

				if not var0_11 then
					local var1_11 = arg0_10:getScore()

					pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_0)
					arg0_10._event:emit(var12_0, {
						score = var1_11,
						pos = arg1_11.position
					})
				end

				arg1_10.readyToRemove = true

				var2_10:SetTrigger("next")

				arg1_10.time = arg1_10.data.time or 3
			end)
		end,
		getScore = function(arg0_12)
			if not arg0_12.additiveScore then
				arg0_12.additiveScore = var7_0
			end

			if arg0_12.scoreTime and arg0_12.timeStep - arg0_12.scoreTime < var8_0 then
				arg0_12.additiveScore = arg0_12.additiveScore + var9_0
			else
				arg0_12.additiveScore = var7_0
			end

			if arg0_12.additiveScore >= var10_0 then
				arg0_12.additiveScore = var10_0
			end

			arg0_12.scoreTime = arg0_12.timeStep

			return arg0_12.additiveScore
		end,
		getAnimTfByPosData = function(arg0_13, arg1_13, arg2_13, arg3_13)
			local var0_13 = arg1_13.anim_name

			if arg0_13._furnitureAnimTfPool and arg0_13._furnitureAnimTfPool[var0_13] and #arg0_13._furnitureAnimTfPool[var0_13] > 0 then
				arg3_13(table.remove(arg0_13._furnitureAnimTfPool[var0_13], 1), arg2_13)

				return
			end

			return arg0_13:createAnimTf(var0_13, arg2_13, arg3_13)
		end,
		returnFurniture = function(arg0_14, arg1_14)
			if not arg1_14 then
				return
			end

			if arg1_14.charIndex then
				arg0_14:returnCharIndex(arg1_14.charIndex)

				arg1_14.charIndex = nil
			end

			if arg1_14.animData and arg1_14.animTf then
				local var0_14 = arg1_14.animData.name

				arg0_14:returnAnimTf(var0_14, arg1_14.animTf)
			end

			if arg1_14.data.hide_tfs then
				for iter0_14 = 1, #arg1_14.data.hide_tfs do
					setActive(findTF(arg1_14.tf, arg1_14.data.hide_tfs[iter0_14]), true)
				end
			end

			arg1_14.animTf = nil
			arg1_14.animData = nil
			arg1_14.activeIndex = nil
			arg1_14.readyToRemove = false
			arg1_14.time = nil

			for iter1_14 = #arg0_14._activeFurnitures, 1, -1 do
				if arg0_14._activeFurnitures[iter1_14] == arg1_14 then
					table.insert(arg0_14._furnituresPools, table.remove(arg0_14._activeFurnitures, iter1_14))
				end
			end

			for iter2_14 = #arg0_14._unActiveFurnitures, 1, -1 do
				if arg0_14._unActiveFurnitures[iter2_14] == arg1_14 then
					table.insert(arg0_14._furnituresPools, table.remove(arg0_14._unActiveFurnitures, iter2_14))
				end
			end

			local var1_14 = false

			for iter3_14 = 1, #arg0_14._furnituresPools do
				if arg0_14._furnituresPools[iter3_14] == arg1_14 then
					var1_14 = true
				end
			end

			if not var1_14 then
				table.insert(arg0_14._furnituresPools, arg1_14)
			end
		end,
		returnAnimTf = function(arg0_15, arg1_15, arg2_15)
			if not arg0_15._furnitureAnimTfPool[arg1_15] then
				arg0_15._furnitureAnimTfPool[arg1_15] = {}
			end

			setActive(arg2_15, false)
			table.insert(arg0_15._furnitureAnimTfPool[arg1_15], arg2_15)
		end,
		createAnimTf = function(arg0_16, arg1_16, arg2_16, arg3_16)
			local var0_16 = var40_0[arg1_16]

			if not var0_16 then
				return nil
			end

			local var1_16 = var0_16.prefab
			local var2_16 = var0_16.name

			if arg0_16._animTplDic[var2_16] then
				arg3_16(tf(Instantiate(arg0_16._animTplDic[var2_16])), arg2_16)
			else
				LoadAndInstantiateAsync(var36_0, var1_16, function(arg0_17)
					if not arg0_17 then
						print("找不到资源" .. var2_16)

						return
					end

					if arg0_16.destroyFlag then
						Destroy(arg0_17)

						return
					end

					arg0_16._animTplDic[var2_16] = arg0_17

					SetParent(tf(arg0_17), arg0_16._tplContainer)
					arg3_16(tf(Instantiate(arg0_16._animTplDic[var2_16])), arg2_16)
				end)
			end
		end,
		getActiveIndex = function(arg0_18)
			if not arg0_18._activeIndex then
				arg0_18._activeIndex = 0
			end

			arg0_18._activeIndex = arg0_18._activeIndex + 1

			return arg0_18._activeIndex
		end,
		clear = function(arg0_19)
			for iter0_19 = #arg0_19._activeFurnitures, 1, -1 do
				arg0_19:returnFurniture(arg0_19._activeFurnitures[iter0_19])
			end

			for iter1_19 = #arg0_19._unActiveFurnitures, 1, -1 do
				arg0_19:returnFurniture(arg0_19._unActiveFurnitures[iter1_19])
			end

			for iter2_19 = 1, #arg0_19._furnituresPools do
				local var0_19 = arg0_19._furnituresPools[iter2_19]

				if var0_19.data.type == var14_0 then
					var0_19.initFlag = false
				end
			end

			arg0_19._activeFurnitures = {}
			var46_0 = Clone(var38_0)
		end,
		destroy = function(arg0_20)
			arg0_20:clear()

			for iter0_20 = 1, #arg0_20._furnitureAnimTfPool do
				local var0_20 = arg0_20._furnitureAnimTfPool[iter0_20].animTf

				if var0_20 then
					local var1_20 = GetOrAddComponent(findTF(var0_20, "collider"), typeof(EventTriggerListener))

					ClearEventTrigger(var1_20)
				end
			end

			arg0_20.destroyFlag = true
		end
	}

	var0_1:ctor()

	return var0_1
end

local var48_0 = {
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
local var49_0 = {
	5,
	10
}
local var50_0 = 300
local var51_0 = 200

local function var52_0(arg0_21, arg1_21)
	local var0_21 = {
		ctor = function(arg0_22)
			arg0_22._tf = arg0_21
			arg0_22._event = arg1_21
			arg0_22._roleTf = findTF(arg0_22._tf, "fushun")
			arg0_22._roleAnimator = GetComponent(findTF(arg0_22._roleTf, "img/anim"), typeof(Animator))
			arg0_22._dftEvent = GetComponent(findTF(arg0_22._roleTf, "img/anim"), typeof(DftAniEvent))

			arg0_22._dftEvent:SetEndEvent(function(arg0_23)
				setActive(arg0_22._roleTf, false)
				arg0_22:clear()
			end)

			arg0_22._eventTrigger = GetOrAddComponent(findTF(arg0_22._roleTf, "img/collider"), typeof(EventTriggerListener))

			arg0_22._eventTrigger:AddPointDownFunc(function(arg0_24, arg1_24, arg2_24)
				if arg0_22.removeRoleFlag then
					return
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_0)
				arg0_22._event:emit(var12_0, {
					score = var11_0,
					pos = arg1_24.position
				})

				arg0_22.removeRoleFlag = true

				arg0_22:setRoleAnimatorTrigger("touch")
			end)

			arg0_22._roleShowData = {}
			arg0_22._roleShowStartData = {}

			for iter0_22 = 1, #var48_0 do
				if var48_0[iter0_22].start then
					table.insert(arg0_22._roleShowStartData, Clone(var48_0[iter0_22]))
				end

				local var0_22 = Clone(var48_0[iter0_22])

				arg0_22._roleShowData[var0_22.name] = var0_22
			end

			arg0_22._active = false
			arg0_22._targetPos = Vector2(0, 0)
			arg0_22._currentTargetData = nil
			arg0_22._currentTargetPos = nil
		end,
		setRoleAnimatorTrigger = function(arg0_25, arg1_25, arg2_25)
			if not arg2_25 then
				arg0_25._roleAnimator:SetTrigger(arg1_25)
			else
				arg0_25._roleAnimator:ResetTrigger(arg1_25)
			end
		end,
		start = function(arg0_26)
			arg0_26.showTime = math.random() * (var49_0[2] - var49_0[1]) + var49_0[1]

			arg0_26:clear()
		end,
		step = function(arg0_27)
			if arg0_27.showTime > 0 then
				arg0_27.showTime = arg0_27.showTime - Time.deltaTime

				if arg0_27.showTime <= 0 then
					arg0_27.showTime = 0

					arg0_27:checkShow()
				end
			end

			if arg0_27._currentTargetData and not arg0_27.removeRoleFlag then
				local var0_27 = arg0_27._roleTf.anchoredPosition
				local var1_27 = var50_0 * math.cos(arg0_27._moveAngle) * Time.deltaTime
				local var2_27 = var50_0 * math.sin(arg0_27._moveAngle) * Time.deltaTime

				if arg0_27._roleDirectX == 1 and arg0_27._roleDirectX * var1_27 + var0_27.x > arg0_27._currentTargetPos.x then
					var0_27.x = var0_27.x + arg0_27._roleDirectX * var1_27
					arg0_27._roleDirectX = nil
				elseif arg0_27._roleDirectX == -1 and arg0_27._roleDirectX * var1_27 + var0_27.x < arg0_27._currentTargetPos.x then
					var0_27.x = var0_27.x + arg0_27._roleDirectX * var1_27
					arg0_27._roleDirectX = nil
				elseif arg0_27._roleDirectX then
					var0_27.x = var0_27.x + arg0_27._roleDirectX * var1_27
				end

				if arg0_27._roleDirectY == 1 and arg0_27._roleDirectY * var2_27 + var0_27.y > arg0_27._currentTargetPos.y then
					var0_27.y = var0_27.y + arg0_27._roleDirectY * var2_27
					arg0_27._roleDirectY = nil
				elseif arg0_27._roleDirectY == -1 and arg0_27._roleDirectY * var2_27 + var0_27.y < arg0_27._currentTargetPos.y then
					var0_27.y = var0_27.y + arg0_27._roleDirectY * var2_27
					arg0_27._roleDirectY = nil
				elseif arg0_27._roleDirectY then
					var0_27.y = var0_27.y + arg0_27._roleDirectY * var2_27
				end

				arg0_27._roleTf.anchoredPosition = var0_27

				if arg0_27._roleDirectX == nil and arg0_27._roleDirectY == nil then
					arg0_27:setRoleNext()
				end
			end
		end,
		setRoleStatus = function(arg0_28, arg1_28)
			setActive(arg0_28._roleTf, true)

			if arg1_28 then
				arg0_28:setRoleAnimatorTrigger("change", true)
				arg0_28:setRoleAnimatorTrigger("hide", true)
				arg0_28:setRoleAnimatorTrigger("show")
			else
				arg0_28:setRoleAnimatorTrigger("change")
			end

			arg0_28._roleAnimator:SetInteger("directX", arg0_28._roleDirectX)
			arg0_28._roleAnimator:SetInteger("directY", arg0_28._roleDirectY)
		end,
		setRoleNext = function(arg0_29, arg1_29)
			if arg1_29 or not arg0_29._currentTargetData.finish then
				local var0_29

				if not arg1_29 then
					var0_29 = arg0_29._currentData.name
					var0_29 = arg0_29._currentData.name
					arg0_29._currentData = arg0_29._currentTargetData
				end

				local var1_29 = Clone(arg0_29._currentData.next)

				if var0_29 then
					for iter0_29 = #var1_29, 1, -1 do
						if var1_29[iter0_29] == var0_29 then
							table.remove(var1_29, iter0_29)
						end
					end
				end

				if #var1_29 == 0 then
					arg0_29:clear()

					return
				end

				local var2_29 = var1_29[math.random(1, #var1_29)]

				arg0_29._currentTargetData = arg0_29._roleShowData[var2_29]

				local var3_29 = findTF(arg0_29._tf, arg0_29._currentData.name)
				local var4_29 = findTF(arg0_29._tf, arg0_29._currentTargetData.name)

				if arg0_29._currentTargetData and arg0_29._currentTargetData.switch_parent then
					setParent(arg0_29._roleTf, var4_29)
				else
					setParent(arg0_29._roleTf, var3_29)
				end

				local var5_29 = findTF(var3_29, "rolePos")

				arg0_29._roleTf.anchoredPosition = var5_29.anchoredPosition
				arg0_29._currentTargetPos = findTF(arg0_29._tf, arg0_29._currentTargetData.name .. "/rolePos").anchoredPosition
				arg0_29._roleDirectX = arg0_29._currentTargetPos.x > arg0_29._roleTf.anchoredPosition.x and 1 or -1
				arg0_29._roleDirectY = arg0_29._currentTargetPos.y > arg0_29._roleTf.anchoredPosition.y and 1 or -1
				arg0_29._moveAngle = math.atan(math.abs(arg0_29._currentTargetPos.y - arg0_29._roleTf.anchoredPosition.y) / math.abs(arg0_29._currentTargetPos.x - arg0_29._roleTf.anchoredPosition.x))
				arg0_29.removeRoleFlag = false

				arg0_29:setRoleStatus(arg1_29)
			elseif arg0_29._currentTargetData.finish then
				arg0_29:clear()
			end
		end,
		checkShow = function(arg0_30)
			if arg0_30._active and not table.contains(var46_0, var37_0) then
				return
			end

			for iter0_30 = #var46_0, 1, -1 do
				if var46_0[iter0_30] == var37_0 then
					table.remove(var46_0, iter0_30)
				end
			end

			arg0_30._active = true
			arg0_30._currentData = arg0_30._roleShowStartData[math.random(1, #arg0_30._roleShowStartData)]

			arg0_30:setRoleNext(true)
		end,
		clear = function(arg0_31)
			arg0_31._currentTargetData = nil
			arg0_31._currentTargetPos = nil

			if not table.contains(var46_0, var37_0) then
				table.insert(var46_0, var37_0)
			end

			if isActive(arg0_31._roleTf) then
				arg0_31:setRoleAnimatorTrigger("hide")

				arg0_31.removeRoleFlag = true

				setActive(arg0_31._roleTf, false)
			end

			arg0_31.showTime = math.random() * (var49_0[2] - var49_0[1]) + var49_0[1]
			arg0_31._active = false
		end,
		destroy = function(arg0_32)
			return
		end
	}

	var0_21:ctor()

	return var0_21
end

local var53_0 = {
	"boot00",
	"boot01",
	"boot02"
}
local var54_0 = {
	"game00",
	"game01",
	"game02"
}
local var55_0 = {
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
local var56_0 = {
	1,
	3
}

local function var57_0(arg0_33, arg1_33)
	local var0_33 = {
		ctor = function(arg0_34)
			arg0_34._tf = arg0_33
			arg0_34._event = arg1_33
			arg0_34.loadedFlag = false
			arg0_34._tvTf = nil
			arg0_34._active = false
			arg0_34._tvAnimator = nil

			onButton(arg0_34._event, findTF(arg0_34._tf, "collider"), function()
				if arg0_34.loadedFlag then
					return
				end

				arg0_34._active = not arg0_34._active

				arg0_34:updateUI()
			end, SFX_CANCEL)
		end,
		start = function(arg0_36)
			arg0_36._active = true

			arg0_36:updateUI()

			if not arg0_36.loadedFlag then
				LoadAndInstantiateAsync(var36_0, var45_0, function(arg0_37)
					if not arg0_37 then
						print("tv资源加载失败")

						return
					end

					if arg0_36.destroyFlag then
						Destroy(arg0_37)

						return
					end

					arg0_36.loadedFlag = true
					arg0_36._tvTf = tf(arg0_37)
					arg0_36._tvAnimator = GetComponent(findTF(arg0_36._tvTf, "anim"), typeof(Animator))

					GetComponent(findTF(arg0_36._tvTf, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
						arg0_36:onTvComplete()
					end)
					onButton(arg0_36._event, findTF(arg0_36._tvTf, "collider"), function()
						arg0_36._active = not arg0_36._active

						arg0_36:updateUI()
					end)
					setParent(arg0_36._tvTf, findTF(arg0_36._tf, "posTv"))
					arg0_36:updateUI()
					arg0_36:setTvData()
				end)
			else
				arg0_36:setTvData()
			end
		end,
		setTvData = function(arg0_40)
			arg0_40.playIndex = 1
			arg0_40.playTvData = {}

			local var0_40 = math.random(var56_0[1], var56_0[2])
			local var1_40 = Clone(var55_0)
			local var2_40 = Clone(var53_0)
			local var3_40 = Clone(var54_0)

			for iter0_40 = 1, var0_40 do
				table.insert(arg0_40.playTvData, table.remove(var1_40, math.random(1, #var1_40)))
			end

			table.insert(arg0_40.playTvData, table.remove(var2_40, math.random(1, #var2_40)))
			table.insert(arg0_40.playTvData, table.remove(var3_40, math.random(1, #var3_40)))
			arg0_40._tvAnimator:Play(arg0_40.playTvData[arg0_40.playIndex], -1, 0)
		end,
		onTvComplete = function(arg0_41)
			if not arg0_41.playIndex and not arg0_41.playTvData and #arg0_41.playTvData == 0 then
				return
			end

			if arg0_41._tvAnimator then
				arg0_41.playIndex = arg0_41.playIndex + 1

				if arg0_41.playIndex > #arg0_41.playTvData then
					arg0_41.playIndex = #arg0_41.playTvData
				end

				arg0_41._tvAnimator:Play(arg0_41.playTvData[arg0_41.playIndex], -1, 0)
			end
		end,
		step = function(arg0_42)
			if arg0_42._tvAnimator and arg0_42._tvAnimator.speed == 0 then
				arg0_42._tvAnimator.speed = 1
			end
		end,
		pause = function(arg0_43)
			if arg0_43._tvAnimator then
				arg0_43._tvAnimator.speed = 0
			end
		end,
		updateUI = function(arg0_44)
			if arg0_44.loadedFlag then
				setActive(findTF(arg0_44._tf, "on"), false)
				setActive(findTF(arg0_44._tf, "off"), false)

				if not arg0_44.tvCanvas then
					arg0_44.tvCanvas = GetComponent(findTF(arg0_44._tvTf, "anim"), typeof(CanvasGroup))
				end

				arg0_44.tvCanvas.alpha = arg0_44._active and 1 or 0
			else
				setActive(findTF(arg0_44._tf, "on"), arg0_44._active)
				setActive(findTF(arg0_44._tf, "off"), not arg0_44._active)
			end
		end,
		destroy = function(arg0_45)
			arg0_45.destroyFlag = true
		end,
		clear = function(arg0_46)
			return
		end
	}

	var0_33:ctor()

	return var0_33
end

function var0_0.getUIName(arg0_47)
	return "HideSeekGameUI"
end

function var0_0.getBGM(arg0_48)
	return var1_0
end

function var0_0.didEnter(arg0_49)
	arg0_49:initEvent()
	arg0_49:initData()
	arg0_49:initUI()
	arg0_49:initGameUI()
	arg0_49:initController()
	arg0_49:updateMenuUI()
	arg0_49:openMenuUI()
end

function var0_0.initEvent(arg0_50)
	if not arg0_50.uiCam then
		arg0_50.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	end

	arg0_50:bind(var12_0, function(arg0_51, arg1_51, arg2_51)
		arg0_50:addScore(arg1_51.score)
		arg0_50:showScore(arg1_51)
	end)
end

function var0_0.showScore(arg0_52, arg1_52)
	local var0_52

	if #arg0_52.showScoresPool > 0 then
		var0_52 = table.remove(arg0_52.showScoresPool, 1)
	else
		var0_52 = tf(Instantiate(arg0_52.showScoreTpl))

		setParent(var0_52, arg0_52.sceneFrontContainer)
		GetComponent(findTF(var0_52, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
			for iter0_53 = #arg0_52.showScores, 1, -1 do
				if var0_52 == arg0_52.showScores[iter0_53] then
					table.insert(arg0_52.showScoresPool, table.remove(arg0_52.showScores, iter0_53))
				end
			end
		end)
	end

	setText(findTF(var0_52, "anim"), "+" .. tostring(arg1_52.score))

	local var1_52 = arg0_52.uiCam:ScreenToWorldPoint(arg1_52.pos)

	var0_52.anchoredPosition = arg0_52.sceneFrontContainer:InverseTransformPoint(var1_52)

	setActive(var0_52, false)
	setActive(var0_52, true)
	table.insert(arg0_52.showScores, var0_52)
end

function var0_0.onEventHandle(arg0_54, arg1_54)
	return
end

function var0_0.initData(arg0_55)
	local var0_55 = Application.targetFrameRate or 60

	if var0_55 > 60 then
		var0_55 = 60
	end

	arg0_55.timer = Timer.New(function()
		arg0_55:onTimer()
	end, 1 / var0_55, -1)
	arg0_55.showScores = {}
	arg0_55.showScoresPool = {}
end

function var0_0.initUI(arg0_57)
	arg0_57.backSceneTf = findTF(arg0_57._tf, "scene_background")
	arg0_57.sceneContainer = findTF(arg0_57._tf, "sceneMask/sceneContainer")
	arg0_57.sceneFrontContainer = findTF(arg0_57._tf, "sceneMask/sceneContainer/scene_front")
	arg0_57.clickMask = findTF(arg0_57._tf, "clickMask")
	arg0_57.bg = findTF(arg0_57._tf, "bg")
	arg0_57.countUI = findTF(arg0_57._tf, "pop/CountUI")
	arg0_57.countAnimator = GetComponent(findTF(arg0_57.countUI, "count"), typeof(Animator))
	arg0_57.countDft = GetOrAddComponent(findTF(arg0_57.countUI, "count"), typeof(DftAniEvent))

	arg0_57.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_57.countDft:SetEndEvent(function()
		setActive(arg0_57.countUI, false)
		arg0_57:gameStart()
	end)

	arg0_57.leaveUI = findTF(arg0_57._tf, "pop/LeaveUI")

	onButton(arg0_57, findTF(arg0_57.leaveUI, "ad/btnOk"), function()
		arg0_57:resumeGame()
		arg0_57:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0_57, findTF(arg0_57.leaveUI, "ad/btnCancel"), function()
		arg0_57:resumeGame()
	end, SFX_CANCEL)

	arg0_57.pauseUI = findTF(arg0_57._tf, "pop/pauseUI")

	onButton(arg0_57, findTF(arg0_57.pauseUI, "ad/btnOk"), function()
		setActive(arg0_57.pauseUI, false)
		arg0_57:resumeGame()
	end, SFX_CANCEL)

	arg0_57.settlementUI = findTF(arg0_57._tf, "pop/SettleMentUI")

	onButton(arg0_57, findTF(arg0_57.settlementUI, "ad/btnOver"), function()
		setActive(arg0_57.settlementUI, false)
		arg0_57:openMenuUI()
	end, SFX_CANCEL)

	arg0_57.menuUI = findTF(arg0_57._tf, "pop/menuUI")
	arg0_57.battleScrollRect = GetComponent(findTF(arg0_57.menuUI, "battList"), typeof(ScrollRect))
	arg0_57.totalTimes = arg0_57:getGameTotalTime()

	local var0_57 = arg0_57:getGameUsedTimes() - 4 < 0 and 0 or arg0_57:getGameUsedTimes() - 4

	scrollTo(arg0_57.battleScrollRect, 0, 1 - var0_57 / (arg0_57.totalTimes - 4))
	onButton(arg0_57, findTF(arg0_57.menuUI, "rightPanelBg/arrowUp"), function()
		local var0_64 = arg0_57.battleScrollRect.normalizedPosition.y + 1 / (arg0_57.totalTimes - 4)

		if var0_64 > 1 then
			var0_64 = 1
		end

		scrollTo(arg0_57.battleScrollRect, 0, var0_64)
	end, SFX_CANCEL)
	onButton(arg0_57, findTF(arg0_57.menuUI, "rightPanelBg/arrowDown"), function()
		local var0_65 = arg0_57.battleScrollRect.normalizedPosition.y - 1 / (arg0_57.totalTimes - 4)

		if var0_65 < 0 then
			var0_65 = 0
		end

		scrollTo(arg0_57.battleScrollRect, 0, var0_65)
	end, SFX_CANCEL)
	onButton(arg0_57, findTF(arg0_57.menuUI, "btnBack"), function()
		arg0_57:closeView()
	end, SFX_CANCEL)
	onButton(arg0_57, findTF(arg0_57.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.five_duomaomao.tip
		})
	end, SFX_CANCEL)
	onButton(arg0_57, findTF(arg0_57.menuUI, "btnStart"), function()
		setActive(arg0_57.menuUI, false)
		arg0_57:readyStart()
	end, SFX_CANCEL)

	local var1_57 = findTF(arg0_57.menuUI, "tplBattleItem")

	arg0_57.battleItems = {}

	for iter0_57 = 1, 7 do
		local var2_57 = tf(instantiate(var1_57))

		var2_57.name = "battleItem_" .. iter0_57

		setParent(var2_57, findTF(arg0_57.menuUI, "battList/Viewport/Content"))

		local var3_57 = iter0_57

		GetSpriteFromAtlasAsync("ui/minigameui/" .. var4_0, "battleDesc" .. var3_57, function(arg0_69)
			setImageSprite(findTF(var2_57, "state_open/buttomDesc"), arg0_69, true)
			setImageSprite(findTF(var2_57, "state_clear/buttomDesc"), arg0_69, true)
			setImageSprite(findTF(var2_57, "state_current/buttomDesc"), arg0_69, true)
			setImageSprite(findTF(var2_57, "state_closed/buttomDesc"), arg0_69, true)
		end)
		setActive(var2_57, true)
		table.insert(arg0_57.battleItems, var2_57)
	end

	if not arg0_57.handle and IsUnityEditor then
		arg0_57.handle = UpdateBeat:CreateListener(arg0_57.Update, arg0_57)

		UpdateBeat:AddListener(arg0_57.handle)
	end
end

function var0_0.initGameUI(arg0_70)
	arg0_70.gameUI = findTF(arg0_70._tf, "ui/gameUI")
	arg0_70.showScoreTpl = findTF(arg0_70.sceneFrontContainer, "score")

	setActive(arg0_70.showScoreTpl, false)
	onButton(arg0_70, findTF(arg0_70.gameUI, "topRight/btnStop"), function()
		arg0_70:stopGame()
		setActive(arg0_70.pauseUI, true)
	end)
	onButton(arg0_70, findTF(arg0_70.gameUI, "btnLeave"), function()
		arg0_70:stopGame()
		setActive(arg0_70.leaveUI, true)
	end)

	arg0_70.gameTimeS = findTF(arg0_70.gameUI, "top/time/s")
	arg0_70.scoreTf = findTF(arg0_70.gameUI, "top/score")
	arg0_70.sceneContainer.anchoredPosition = Vector2(0, 0)

	local var0_70 = GetOrAddComponent(arg0_70.sceneContainer, typeof(EventTriggerListener))
	local var1_70
	local var2_70

	arg0_70.velocityXSmoothing = Vector2(0, 0)
	arg0_70.offsetPosition = arg0_70.sceneContainer.anchoredPosition

	var0_70:AddBeginDragFunc(function(arg0_73, arg1_73)
		var1_70 = arg1_73.position
		var2_70 = arg0_70.sceneContainer.anchoredPosition
		arg0_70.velocityXSmoothing = Vector2(0, 0)
		arg0_70.offsetPosition = arg0_70.sceneContainer.anchoredPosition
	end)
	var0_70:AddDragFunc(function(arg0_74, arg1_74)
		arg0_70.offsetPosition.x = arg1_74.position.x - var1_70.x + var2_70.x
		arg0_70.offsetPosition.y = arg1_74.position.y - var1_70.y + var2_70.y
		arg0_70.offsetPosition.x = arg0_70.offsetPosition.x > var42_0[2] and var42_0[2] or arg0_70.offsetPosition.x
		arg0_70.offsetPosition.x = arg0_70.offsetPosition.x < var42_0[1] and var42_0[1] or arg0_70.offsetPosition.x
		arg0_70.offsetPosition.y = arg0_70.offsetPosition.y > var43_0[2] and var43_0[2] or arg0_70.offsetPosition.y
		arg0_70.offsetPosition.y = arg0_70.offsetPosition.y < var43_0[1] and var43_0[1] or arg0_70.offsetPosition.y
	end)
	var0_70:AddDragEndFunc(function(arg0_75, arg1_75)
		return
	end)
end

function var0_0.initController(arg0_76)
	arg0_76.furnitureCtrl = var47_0(findTF(arg0_76.sceneContainer, "scene"), arg0_76)
	arg0_76.moveRoleCtrl = var52_0(findTF(arg0_76.sceneContainer, "scene"), arg0_76)
	arg0_76.tvCtrl = var57_0(findTF(arg0_76.sceneContainer, "scene/furniture_tv"), arg0_76)
end

function var0_0.Update(arg0_77)
	arg0_77:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_78)
	if arg0_78.gameStop or arg0_78.settlementFlag then
		return
	end

	if IsUnityEditor and Input.GetKeyDown(KeyCode.S) then
		-- block empty
	end
end

function var0_0.updateMenuUI(arg0_79)
	local var0_79 = arg0_79:getGameUsedTimes()
	local var1_79 = arg0_79:getGameTimes()

	for iter0_79 = 1, #arg0_79.battleItems do
		setActive(findTF(arg0_79.battleItems[iter0_79], "state_open"), false)
		setActive(findTF(arg0_79.battleItems[iter0_79], "state_closed"), false)
		setActive(findTF(arg0_79.battleItems[iter0_79], "state_clear"), false)
		setActive(findTF(arg0_79.battleItems[iter0_79], "state_current"), false)

		if iter0_79 <= var0_79 then
			setActive(findTF(arg0_79.battleItems[iter0_79], "state_clear"), true)
		elseif iter0_79 == var0_79 + 1 and var1_79 >= 1 then
			setActive(findTF(arg0_79.battleItems[iter0_79], "state_current"), true)
		elseif var0_79 < iter0_79 and iter0_79 <= var0_79 + var1_79 then
			setActive(findTF(arg0_79.battleItems[iter0_79], "state_open"), true)
		else
			setActive(findTF(arg0_79.battleItems[iter0_79], "state_closed"), true)
		end
	end

	arg0_79.totalTimes = arg0_79:getGameTotalTime()

	local var2_79 = 1 - (arg0_79:getGameUsedTimes() - 3 < 0 and 0 or arg0_79:getGameUsedTimes() - 3) / (arg0_79.totalTimes - 4)

	if var2_79 > 1 then
		var2_79 = 1
	end

	scrollTo(arg0_79.battleScrollRect, 0, var2_79)
	setActive(findTF(arg0_79.menuUI, "btnStart/tip"), var1_79 > 0)
	arg0_79:CheckGet()
end

function var0_0.CheckGet(arg0_80)
	setActive(findTF(arg0_80.menuUI, "got"), false)

	if arg0_80:getUltimate() and arg0_80:getUltimate() ~= 0 then
		setActive(findTF(arg0_80.menuUI, "got"), true)
	end

	if arg0_80:getUltimate() == 0 then
		if arg0_80:getGameTotalTime() > arg0_80:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_80:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0_80.menuUI, "got"), true)
	end
end

function var0_0.openMenuUI(arg0_81)
	setActive(findTF(arg0_81.sceneContainer, "scene_front"), false)
	setActive(findTF(arg0_81.sceneContainer, "scene_background"), false)
	setActive(findTF(arg0_81.sceneContainer, "scene"), false)
	setActive(arg0_81.gameUI, false)
	setActive(arg0_81.menuUI, true)
	setActive(arg0_81.bg, true)
	arg0_81:updateMenuUI()
end

function var0_0.clearUI(arg0_82)
	setActive(arg0_82.sceneContainer, false)
	setActive(arg0_82.settlementUI, false)
	setActive(arg0_82.countUI, false)
	setActive(arg0_82.menuUI, false)
	setActive(arg0_82.gameUI, false)
end

function var0_0.readyStart(arg0_83)
	setActive(arg0_83.countUI, true)
	arg0_83.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)
end

function var0_0.gameStart(arg0_84)
	setActive(findTF(arg0_84.sceneContainer, "scene_front"), true)
	setActive(findTF(arg0_84.sceneContainer, "scene_background"), true)
	setActive(findTF(arg0_84.sceneContainer, "scene"), true)
	setActive(arg0_84.bg, false)

	arg0_84.sceneContainer.anchoredPosition = var44_0
	arg0_84.offsetPosition = var44_0

	setActive(arg0_84.gameUI, true)

	arg0_84.gameStartFlag = true
	arg0_84.scoreNum = 0
	arg0_84.nextPositionIndex = 2
	arg0_84.gameStepTime = 0
	arg0_84.heart = 3
	arg0_84.gameTime = var5_0

	for iter0_84 = #arg0_84.showScores, 1, -1 do
		if not table.contains(arg0_84.showScoresPool, arg0_84.showScores[iter0_84]) then
			local var0_84 = table.remove(arg0_84.showScores, iter0_84)

			table.insert(arg0_84.showScoresPool, var0_84)
		end
	end

	for iter1_84 = #arg0_84.showScoresPool, 1, -1 do
		setActive(arg0_84.showScoresPool[iter1_84], false)
	end

	arg0_84:updateGameUI()
	arg0_84:timerStart()
	arg0_84:controllerStart()
end

function var0_0.controllerStart(arg0_85)
	if arg0_85.furnitureCtrl then
		arg0_85.furnitureCtrl:start()
	end

	if arg0_85.moveRoleCtrl then
		arg0_85.moveRoleCtrl:start()
	end

	if arg0_85.tvCtrl then
		arg0_85.tvCtrl:start()
	end
end

function var0_0.getGameTimes(arg0_86)
	return arg0_86:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_87)
	return arg0_87:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_88)
	return arg0_88:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_89)
	return (arg0_89:GetMGHubData():getConfig("reward_need"))
end

function var0_0.changeSpeed(arg0_90, arg1_90)
	return
end

function var0_0.onTimer(arg0_91)
	arg0_91:gameStep()
end

function var0_0.gameStep(arg0_92)
	arg0_92.gameTime = arg0_92.gameTime - Time.deltaTime

	if arg0_92.gameTime < 0 then
		arg0_92.gameTime = 0
	end

	arg0_92.gameStepTime = arg0_92.gameStepTime + Time.deltaTime

	arg0_92:controllerStep()
	arg0_92:updateGameUI()

	if arg0_92.gameTime <= 0 then
		arg0_92:onGameOver()

		return
	end
end

function var0_0.controllerStep(arg0_93)
	if arg0_93.furnitureCtrl then
		arg0_93.furnitureCtrl:step()
	end

	if arg0_93.moveRoleCtrl then
		arg0_93.moveRoleCtrl:step()
	end

	if arg0_93.tvCtrl then
		arg0_93.tvCtrl:step()
	end
end

function var0_0.timerStart(arg0_94)
	if not arg0_94.timer.running then
		arg0_94.timer:Start()
	end
end

function var0_0.timerStop(arg0_95)
	if arg0_95.timer.running then
		arg0_95.timer:Stop()

		if arg0_95.tvCtrl then
			arg0_95.tvCtrl:pause()
		end
	end
end

function var0_0.updateGameUI(arg0_96)
	setText(arg0_96.scoreTf, arg0_96.scoreNum)
	setText(arg0_96.gameTimeS, math.ceil(arg0_96.gameTime))

	arg0_96.sceneContainer.anchoredPosition, arg0_96.velocityXSmoothing = Vector2.SmoothDamp(arg0_96.sceneContainer.anchoredPosition, arg0_96.offsetPosition, arg0_96.velocityXSmoothing, var41_0)
end

function var0_0.addScore(arg0_97, arg1_97)
	arg0_97.scoreNum = arg0_97.scoreNum + arg1_97

	if arg0_97.scoreNum < 0 then
		arg0_97.scoreNum = 0
	end
end

function var0_0.onGameOver(arg0_98)
	if arg0_98.settlementFlag then
		return
	end

	arg0_98:timerStop()

	arg0_98.settlementFlag = true

	setActive(arg0_98.clickMask, true)
	LeanTween.delayedCall(go(arg0_98._tf), 0.1, System.Action(function()
		arg0_98.settlementFlag = false
		arg0_98.gameStartFlag = false

		setActive(arg0_98.clickMask, false)
		arg0_98:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_100)
	setActive(arg0_100.settlementUI, true)
	GetComponent(findTF(arg0_100.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_100 = arg0_100:GetMGData():GetRuntimeData("elements")
	local var1_100 = arg0_100.scoreNum
	local var2_100 = var0_100 and #var0_100 > 0 and var0_100[1] or 0

	setActive(findTF(arg0_100.settlementUI, "ad/new"), var2_100 < var1_100)

	if var2_100 <= var1_100 then
		var2_100 = var1_100

		arg0_100:StoreDataToServer({
			var2_100
		})
	end

	local var3_100 = findTF(arg0_100.settlementUI, "ad/highText")
	local var4_100 = findTF(arg0_100.settlementUI, "ad/currentText")

	setText(var3_100, var2_100)
	setText(var4_100, var1_100)

	if arg0_100:getGameTimes() and arg0_100:getGameTimes() > 0 then
		arg0_100.sendSuccessFlag = true

		arg0_100:SendSuccess(0)
	end
end

function var0_0.resumeGame(arg0_101)
	arg0_101.gameStop = false

	setActive(arg0_101.leaveUI, false)
	arg0_101:changeSpeed(1)
	arg0_101:timerStart()
end

function var0_0.stopGame(arg0_102)
	arg0_102.gameStop = true

	arg0_102:timerStop()
	arg0_102:changeSpeed(0)
end

function var0_0.onBackPressed(arg0_103)
	if not arg0_103.gameStartFlag then
		arg0_103:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_103.settlementFlag then
			return
		end

		if isActive(arg0_103.pauseUI) then
			setActive(arg0_103.pauseUI, false)
		end

		arg0_103:stopGame()
		setActive(arg0_103.leaveUI, true)
	end
end

function var0_0.willExit(arg0_104)
	if arg0_104.handle then
		UpdateBeat:RemoveListener(arg0_104.handle)
	end

	if arg0_104._tf and LeanTween.isTweening(go(arg0_104._tf)) then
		LeanTween.cancel(go(arg0_104._tf))
	end

	arg0_104:destroyController()

	if arg0_104.timer and arg0_104.timer.running then
		arg0_104.timer:Stop()
	end

	Time.timeScale = 1
	arg0_104.timer = nil
end

function var0_0.destroyController(arg0_105)
	if arg0_105.furnitureCtrl then
		arg0_105.furnitureCtrl:destroy()
	end

	if arg0_105.moveRoleCtrl then
		arg0_105.moveRoleCtrl:destroy()
	end

	if arg0_105.tvCtrl then
		arg0_105.tvCtrl:destroy()
	end
end

return var0_0
