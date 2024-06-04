local var0 = class("SVDebugPanel", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SVDebugPanel"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	local var0 = arg0._tf

	arg0.scrollRect = var0:Find("scrollview"):GetComponent(typeof(ScrollRect))
	arg0.rtContent = var0:Find("scrollview/viewport/content")
	arg0.rtText = arg0.rtContent:Find("text")
	arg0.btnX = var0:Find("panel/x")

	onButton(arg0, arg0.btnX, function()
		arg0:Hide()
	end)

	local var1 = var0:Find("panel/buttons")
	local var2 = var1:Find("button")

	setActive(arg0.rtText, false)
	setParent(arg0.rtText, var0, false)

	local var3 = nowWorld()
	local var4 = {
		{
			name = "清理打印",
			func = function()
				for iter0 = arg0.rtContent.childCount - 1, 0, -1 do
					Destroy(arg0.rtContent:GetChild(iter0))
				end
			end
		},
		{
			name = "entity缓存",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("打印entity缓存信息：")

				local var0 = {}

				for iter0, iter1 in pairs(WPool.pools) do
					table.insert(var0, iter0.__cname .. " : " .. #iter1)
				end

				table.sort(var0)

				for iter2, iter3 in ipairs(var0) do
					arg0:AppendText(iter3)
				end

				arg0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "地图信息",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("当前大世界进度：")
				arg0:AppendText(tostring(var3:GetProgress()))
				arg0:AppendText("")
				arg0:AppendText("当前所在入口信息：")

				local var0 = var3:GetActiveEntrance()

				if var0 then
					arg0:AppendText(var0:DebugPrint())
				end

				arg0:AppendText("")
				arg0:AppendText("当前所在地图信息：")

				local var1 = var3:GetActiveMap()

				if var1 then
					arg0:AppendText(var1:DebugPrint())
				end

				arg0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "任务信息",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("任务信息：")

				local var0 = var3:GetTaskProxy():getTasks()

				for iter0, iter1 in pairs(var0) do
					arg0:AppendText(iter1:DebugPrint())
				end

				arg0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "事件信息",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("事件信息：")

				local var0 = var3:GetActiveMap()

				if var0 then
					local var1 = var0:FindAttachments(WorldMapAttachment.TypeEvent)

					_.each(var1, function(arg0)
						arg0:AppendText(arg0:DebugPrint())
					end)
				end

				arg0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "感染事件",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("感染事件：")

				local var0 = var3:GetActiveMap()

				if var0 then
					local var1 = var0:FindAttachments(WorldMapAttachment.TypeEvent)

					_.each(var1, function(arg0)
						if arg0.config.infection_value > 0 then
							arg0:AppendText(arg0:DebugPrint())
						end
					end)
				end

				arg0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "路标事件",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("路标事件：")

				local var0 = var3:GetActiveMap()

				if var0 then
					local var1 = var0:FindAttachments(WorldMapAttachment.TypeEvent)

					_.each(var1, function(arg0)
						if arg0:IsSign() then
							arg0:AppendText(arg0:DebugPrint())
						end
					end)
				end

				arg0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "舰队信息",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("打印舰队信息：")
				_.each(var3:GetFleets(), function(arg0)
					arg0:AppendText(arg0:DebugPrint())
				end)
				arg0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "敌人信息",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("打印敌人信息：")

				local var0 = var3:GetActiveMap()

				if var0 then
					local var1 = var0:FindEnemys()

					_.each(var1, function(arg0)
						arg0:AppendText(arg0:DebugPrint())
					end)
				end

				arg0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "陷阱信息",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("打印陷阱信息：")

				local var0 = var3:GetActiveMap()

				if var0 then
					local var1 = var0:FindAttachments(WorldMapAttachment.TypeTrap)

					_.each(var1, function(arg0)
						arg0:AppendText(arg0:DebugPrint())
					end)
				end

				arg0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "场景物件",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("当前所在地图场景物件信息：")

				local var0 = var3:GetActiveMap()

				if var0 then
					local var1 = var0:FindAttachments(WorldMapAttachment.TypeArtifact)

					_.each(var1, function(arg0)
						arg0:AppendText(arg0:DebugPrint())
					end)
				end

				arg0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "一键压制",
			func = function()
				arg0:AppendText("-------------------------------------------------------------------------")
				arg0:AppendText("当前地图压制啦")

				local var0 = var3:GetAtlas()

				var0:AddPressingMap(var0.activeMapId)
				arg0:AppendText("-------------------------------------------------------------------------")
			end
		}
	}
	local var5 = UIItemList.New(var1, var2)

	var5:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			setText(arg2:Find("Text"), var4[arg1].name)
			onButton(arg0, arg2, var4[arg1].func)
		end
	end)
	var5:align(#var4)
end

function var0.OnDestroy(arg0)
	setParent(arg0.rtText, arg0.rtContent, false)
end

function var0.Show(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
	setActive(arg0._tf, true)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.Setup(arg0)
	return
end

function var0.OnClickRichText(arg0, arg1, arg2)
	if arg1 == "ShipProperty" then
		local var0 = tonumber(arg2)
		local var1 = nowWorld():GetShipVO(var0)

		assert(var1, "ship not exist: " .. var0)
		arg0:AppendText("-------------------------------------------------------------------------")
		arg0:AppendText("打印舰娘属性：")
		arg0:AppendText(string.format("[%s] [id: %s] [config_id: %s]", var1:getName(), var1.id, var1.configId))

		local var2 = {
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
		local var3 = var1:getProperties()

		for iter0, iter1 in ipairs(var2) do
			local var4

			if iter1[1] == AttributeType.Armor then
				var4 = var1:getShipArmorName()
			else
				var4 = var3[iter1[1]]
			end

			if var4 then
				arg0:AppendText(string.format("\t\t%s[%s] : <color=#A9F548>%s</color>", iter1[1], iter1[2], var4))
			end
		end

		arg0:AppendText("-------------------------------------------------------------------------")
	end
end

function var0.AppendText(arg0, arg1)
	local var0 = cloneTplTo(arg0.rtText, arg0.rtContent, false)

	var0:GetComponent("RichText"):AddListener(function(arg0, arg1)
		arg0:OnClickRichText(arg0, arg1)
	end)
	setText(var0, arg1)
	print(arg1)
end

return var0
