local var0_0 = class("SVDebugPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SVDebugPanel"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	local var0_3 = arg0_3._tf

	arg0_3.scrollRect = var0_3:Find("scrollview"):GetComponent(typeof(ScrollRect))
	arg0_3.rtContent = var0_3:Find("scrollview/viewport/content")
	arg0_3.rtText = arg0_3.rtContent:Find("text")
	arg0_3.btnX = var0_3:Find("panel/x")

	onButton(arg0_3, arg0_3.btnX, function()
		arg0_3:Hide()
	end)

	local var1_3 = var0_3:Find("panel/buttons")
	local var2_3 = var1_3:Find("button")

	setActive(arg0_3.rtText, false)
	setParent(arg0_3.rtText, var0_3, false)

	local var3_3 = nowWorld()
	local var4_3 = {
		{
			name = "清理打印",
			func = function()
				for iter0_5 = arg0_3.rtContent.childCount - 1, 0, -1 do
					Destroy(arg0_3.rtContent:GetChild(iter0_5))
				end
			end
		},
		{
			name = "entity缓存",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("打印entity缓存信息：")

				local var0_6 = {}

				for iter0_6, iter1_6 in pairs(WPool.pools) do
					table.insert(var0_6, iter0_6.__cname .. " : " .. #iter1_6)
				end

				table.sort(var0_6)

				for iter2_6, iter3_6 in ipairs(var0_6) do
					arg0_3:AppendText(iter3_6)
				end

				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "地图信息",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("当前大世界进度：")
				arg0_3:AppendText(tostring(var3_3:GetProgress()))
				arg0_3:AppendText("")
				arg0_3:AppendText("当前所在入口信息：")

				local var0_7 = var3_3:GetActiveEntrance()

				if var0_7 then
					arg0_3:AppendText(var0_7:DebugPrint())
				end

				arg0_3:AppendText("")
				arg0_3:AppendText("当前所在地图信息：")

				local var1_7 = var3_3:GetActiveMap()

				if var1_7 then
					arg0_3:AppendText(var1_7:DebugPrint())
				end

				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "任务信息",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("任务信息：")

				local var0_8 = var3_3:GetTaskProxy():getTasks()

				for iter0_8, iter1_8 in pairs(var0_8) do
					arg0_3:AppendText(iter1_8:DebugPrint())
				end

				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "事件信息",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("事件信息：")

				local var0_9 = var3_3:GetActiveMap()

				if var0_9 then
					local var1_9 = var0_9:FindAttachments(WorldMapAttachment.TypeEvent)

					_.each(var1_9, function(arg0_10)
						arg0_3:AppendText(arg0_10:DebugPrint())
					end)
				end

				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "感染事件",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("感染事件：")

				local var0_11 = var3_3:GetActiveMap()

				if var0_11 then
					local var1_11 = var0_11:FindAttachments(WorldMapAttachment.TypeEvent)

					_.each(var1_11, function(arg0_12)
						if arg0_12.config.infection_value > 0 then
							arg0_3:AppendText(arg0_12:DebugPrint())
						end
					end)
				end

				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "路标事件",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("路标事件：")

				local var0_13 = var3_3:GetActiveMap()

				if var0_13 then
					local var1_13 = var0_13:FindAttachments(WorldMapAttachment.TypeEvent)

					_.each(var1_13, function(arg0_14)
						if arg0_14:IsSign() then
							arg0_3:AppendText(arg0_14:DebugPrint())
						end
					end)
				end

				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "舰队信息",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("打印舰队信息：")
				_.each(var3_3:GetFleets(), function(arg0_16)
					arg0_3:AppendText(arg0_16:DebugPrint())
				end)
				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "敌人信息",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("打印敌人信息：")

				local var0_17 = var3_3:GetActiveMap()

				if var0_17 then
					local var1_17 = var0_17:FindEnemys()

					_.each(var1_17, function(arg0_18)
						arg0_3:AppendText(arg0_18:DebugPrint())
					end)
				end

				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "陷阱信息",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("打印陷阱信息：")

				local var0_19 = var3_3:GetActiveMap()

				if var0_19 then
					local var1_19 = var0_19:FindAttachments(WorldMapAttachment.TypeTrap)

					_.each(var1_19, function(arg0_20)
						arg0_3:AppendText(arg0_20:DebugPrint())
					end)
				end

				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "场景物件",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("当前所在地图场景物件信息：")

				local var0_21 = var3_3:GetActiveMap()

				if var0_21 then
					local var1_21 = var0_21:FindAttachments(WorldMapAttachment.TypeArtifact)

					_.each(var1_21, function(arg0_22)
						arg0_3:AppendText(arg0_22:DebugPrint())
					end)
				end

				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "一键压制",
			func = function()
				arg0_3:AppendText("-------------------------------------------------------------------------")
				arg0_3:AppendText("当前地图压制啦")

				local var0_23 = var3_3:GetAtlas()

				var0_23:AddPressingMap(var0_23.activeMapId)
				arg0_3:AppendText("-------------------------------------------------------------------------")
			end
		}
	}
	local var5_3 = UIItemList.New(var1_3, var2_3)

	var5_3:make(function(arg0_24, arg1_24, arg2_24)
		arg1_24 = arg1_24 + 1

		if arg0_24 == UIItemList.EventUpdate then
			setText(arg2_24:Find("Text"), var4_3[arg1_24].name)
			onButton(arg0_3, arg2_24, var4_3[arg1_24].func)
		end
	end)
	var5_3:align(#var4_3)
end

function var0_0.OnDestroy(arg0_25)
	setParent(arg0_25.rtText, arg0_25.rtContent, false)
end

function var0_0.Show(arg0_26)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_26._tf)
	setActive(arg0_26._tf, true)
end

function var0_0.Hide(arg0_27)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_27._tf, arg0_27._parentTf)
	setActive(arg0_27._tf, false)
end

function var0_0.Setup(arg0_28)
	return
end

function var0_0.OnClickRichText(arg0_29, arg1_29, arg2_29)
	if arg1_29 == "ShipProperty" then
		local var0_29 = tonumber(arg2_29)
		local var1_29 = nowWorld():GetShipVO(var0_29)

		assert(var1_29, "ship not exist: " .. var0_29)
		arg0_29:AppendText("-------------------------------------------------------------------------")
		arg0_29:AppendText("打印舰娘属性：")
		arg0_29:AppendText(string.format("[%s] [id: %s] [config_id: %s]", var1_29:getName(), var1_29.id, var1_29.configId))

		local var2_29 = {
			{
				AttributeType.Durability,
				"耐久"
			},
			{
				AttributeType.Cannon,
				"炮击"
			},
			{
				AttributeType.Torpedo,
				"雷击"
			},
			{
				AttributeType.AntiAircraft,
				"防空"
			},
			{
				AttributeType.AntiSub,
				"反潜"
			},
			{
				AttributeType.Air,
				"航空"
			},
			{
				AttributeType.Reload,
				"装填"
			},
			{
				AttributeType.CD,
				"射速"
			},
			{
				AttributeType.Armor,
				"装甲"
			},
			{
				AttributeType.Hit,
				"命中"
			},
			{
				AttributeType.Speed,
				"航速"
			},
			{
				AttributeType.Luck,
				"幸运"
			},
			{
				AttributeType.Dodge,
				"机动"
			},
			{
				AttributeType.Expend,
				"消耗"
			},
			{
				AttributeType.Damage,
				"伤害"
			},
			{
				AttributeType.Healthy,
				"治疗"
			},
			{
				AttributeType.Speciality,
				"特性"
			},
			{
				AttributeType.Range,
				"射程"
			},
			{
				AttributeType.Angle,
				"射角"
			},
			{
				AttributeType.Scatter,
				"散布"
			},
			{
				AttributeType.Ammo,
				"弹药"
			},
			{
				AttributeType.HuntingRange,
				"狩猎范围"
			},
			{
				AttributeType.OxyMax,
				"氧气最大含量"
			},
			{
				AttributeType.OxyCost,
				"氧气秒消耗"
			},
			{
				AttributeType.OxyRecovery,
				"氧气秒恢复"
			},
			{
				AttributeType.OxyAttackDuration,
				"水面攻击持续时长"
			},
			{
				AttributeType.OxyRaidDistance,
				"水下攻击持续时长"
			},
			{
				AttributeType.SonarRange,
				"声呐范围"
			},
			{
				AttributeType.SonarInterval,
				"声呐间隔"
			},
			{
				AttributeType.SonarDuration,
				"声呐效果持续时间"
			}
		}
		local var3_29 = var1_29:getProperties()

		for iter0_29, iter1_29 in ipairs(var2_29) do
			local var4_29

			if iter1_29[1] == AttributeType.Armor then
				var4_29 = var1_29:getShipArmorName()
			else
				var4_29 = var3_29[iter1_29[1]]
			end

			if var4_29 then
				arg0_29:AppendText(string.format("\t\t%s[%s] : <color=#A9F548>%s</color>", iter1_29[1], iter1_29[2], var4_29))
			end
		end

		arg0_29:AppendText("-------------------------------------------------------------------------")
	end
end

function var0_0.AppendText(arg0_30, arg1_30)
	local var0_30 = cloneTplTo(arg0_30.rtText, arg0_30.rtContent, false)

	var0_30:GetComponent("RichText"):AddListener(function(arg0_31, arg1_31)
		arg0_30:OnClickRichText(arg0_31, arg1_31)
	end)
	setText(var0_30, arg1_30)
	print(arg1_30)
end

return var0_0
