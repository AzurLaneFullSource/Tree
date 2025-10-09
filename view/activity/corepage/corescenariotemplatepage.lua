local var0_0 = class("CoreScenarioTemplatePage", import("view.base.BaseSubView"))
local var1_0 = import("Mgr/Pool/PoolPlural")

function var0_0.getUIName(arg0_1)
	return "AEBCSScenarioPage"
end

function var0_0.OnInit(arg0_2)
	arg0_2.storyLayer = arg0_2._tf:Find("Story")
	arg0_2.top = arg0_2._tf:Find("Top")
	arg0_2.storyHolder = arg0_2._tf:Find("Story/Nodes")
	arg0_2.storyContainer = arg0_2.storyHolder:Find("Viewport/Content")
	arg0_2.nodes = {}
	arg0_2.progressText = arg0_2._tf:Find("Story/Desc/Text")
	arg0_2.storyAward = arg0_2._tf:Find("Story/Award")
	arg0_2.storyNodeTpl = arg0_2._tf:Find("Story/NodeTemplate")
	arg0_2.oneLineTpl = arg0_2._tf:Find("Story/OneLine")
	arg0_2.branchHeadTpl = arg0_2._tf:Find("Story/BranchHead")
	arg0_2.branchCenterTpl = arg0_2._tf:Find("Story/BranchCenter")
	arg0_2.branchUpTpl = arg0_2._tf:Find("Story/BranchUp")
	arg0_2.branchDownTpl = arg0_2._tf:Find("Story/BranchDown")
	arg0_2.unionTailTpl = arg0_2._tf:Find("Story/UnionTail")
	arg0_2.unionCenterTpl = arg0_2._tf:Find("Story/UnionCenter")
	arg0_2.unionUpTpl = arg0_2._tf:Find("Story/UnionUp")
	arg0_2.unionDownTpl = arg0_2._tf:Find("Story/UnionDown")

	setActive(arg0_2.storyNodeTpl, false)
	setActive(arg0_2.oneLineTpl, false)
	setActive(arg0_2.branchHeadTpl, false)
	setActive(arg0_2.branchCenterTpl, false)
	setActive(arg0_2.branchUpTpl, false)
	setActive(arg0_2.branchDownTpl, false)
	setActive(arg0_2.unionTailTpl, false)
	setActive(arg0_2.unionCenterTpl, false)
	setActive(arg0_2.unionUpTpl, false)
	setActive(arg0_2.unionDownTpl, false)

	arg0_2.pools = {
		[arg0_2.storyNodeTpl] = var1_0.New(go(arg0_2.storyNodeTpl), 0),
		[arg0_2.oneLineTpl] = var1_0.New(go(arg0_2.oneLineTpl), 0),
		[arg0_2.branchHeadTpl] = var1_0.New(go(arg0_2.branchHeadTpl), 0),
		[arg0_2.branchCenterTpl] = var1_0.New(go(arg0_2.branchCenterTpl), 0),
		[arg0_2.branchUpTpl] = var1_0.New(go(arg0_2.branchUpTpl), 0),
		[arg0_2.branchDownTpl] = var1_0.New(go(arg0_2.branchDownTpl), 0),
		[arg0_2.unionTailTpl] = var1_0.New(go(arg0_2.unionTailTpl), 0),
		[arg0_2.unionCenterTpl] = var1_0.New(go(arg0_2.unionCenterTpl), 0),
		[arg0_2.unionUpTpl] = var1_0.New(go(arg0_2.unionUpTpl), 0),
		[arg0_2.unionDownTpl] = var1_0.New(go(arg0_2.unionDownTpl), 0)
	}
	arg0_2.nodeTplWidth = arg0_2.storyNodeTpl.rect.width
	arg0_2.oneLineWidth = arg0_2.oneLineTpl.rect.width
	arg0_2.oneLineHeight = arg0_2.oneLineTpl.rect.height
	arg0_2.branchHeadWidth = arg0_2.branchHeadTpl.rect.width
	arg0_2.branchUpWidth = arg0_2.branchUpTpl.rect.width
	arg0_2.branchUpHeight = arg0_2.branchUpTpl.rect.height
	arg0_2.UnionTailWidth = arg0_2.unionTailTpl.rect.width
	arg0_2.activeItems = {}
	arg0_2.displayChapterIDs = {}
	arg0_2.chapterTFsById = {}
	arg0_2.storyNodeTFsById = {}

	setText(arg0_2.storyLayer:Find("Desc/Desc"), i18n("series_enemy_storyreward"))
end

function var0_0.SetCoreStoryPage(arg0_3, arg1_3)
	arg0_3.coreStoryPage = arg1_3
end

function var0_0.SetActivity(arg0_4, arg1_4)
	arg0_4.activity = arg1_4

	arg0_4:BuildStoryTree()
end

function var0_0.BuildStoryTree(arg0_5)
	arg0_5.spStoryIDs = arg0_5.activity:getConfig("config_client").storys
	arg0_5.spStoryNodes = {}

	_.each(arg0_5.spStoryIDs, function(arg0_6)
		table.insert(arg0_5.spStoryNodes, ActivitySpStoryNode.New({
			configId = arg0_6
		}))
	end)

	arg0_5.nodeRootList, arg0_5.nodeChildDict = {}, {}

	_.each(arg0_5.spStoryNodes, function(arg0_7)
		local var0_7 = arg0_7:GetPreNodes()

		if #var0_7 == 0 then
			table.insert(arg0_5.nodeRootList, arg0_7)
		else
			_.each(var0_7, function(arg0_8)
				arg0_5.nodeChildDict[arg0_8] = arg0_5.nodeChildDict[arg0_8] or {}

				table.insert(arg0_5.nodeChildDict[arg0_8], arg0_7)
			end)
		end
	end)
end

function var0_0.UpdateView(arg0_9)
	arg0_9:UpdateStoryNodeStatus()
	arg0_9:UpdateStory()
	arg0_9:Move2UnlockStory()
	arg0_9:SwitchStoryMapAndBGM()
	setActive(arg0_9.storyLayer, true)
	arg0_9:TrySubmitTask()
end

function var0_0.RecyclePools(arg0_10)
	for iter0_10 = #arg0_10.activeItems, 1, -1 do
		local var0_10 = arg0_10.activeItems[iter0_10]
		local var1_10 = arg0_10.pools[var0_10.template]

		if var0_10.template == arg0_10.oneLineTpl then
			setSizeDelta(var0_10.active, {
				x = arg0_10.oneLineWidth,
				y = arg0_10.oneLineHeight
			})
		end

		var1_10:Enqueue(var0_10.active)
	end

	table.clean(arg0_10.activeItems)

	arg0_10.storyNodeTFsById = {}
end

local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.UpdateStoryNodeStatus(arg0_11)
	local var0_11 = 0
	local var1_11 = 0
	local var2_11 = pg.NewStoryMgr.GetInstance()
	local var3_11 = {}

	table.Foreach(arg0_11.spStoryIDs, function(arg0_12, arg1_12)
		var3_11[arg1_12] = {}
	end)

	local var4_11 = arg0_11.spStoryNodes

	for iter0_11 = 1, #var4_11 do
		local var5_11 = var4_11[iter0_11]
		local var6_11 = var5_11:GetConfigID()
		local var7_11 = var5_11:GetPreEvent()
		local var8_11 = false
		local var9_11 = var7_11 == 0 and true or var3_11[var7_11].status == var4_0
		local var10_11 = var2_0
		local var11_11 = var5_11:GetStoryName()
		local var12_11 = false

		if var11_11 and var11_11 ~= "" then
			var12_11 = var2_11:IsPlayed(var11_11)
			var0_11 = var0_11 + (var12_11 and 1 or 0)
			var1_11 = var1_11 + 1
		end

		if not var12_11 and var9_11 then
			_.each(var5_11:GetUnlockConditions(), function(arg0_13)
				if arg0_13[1] == ActivitySpStoryNode.CONDITION.TIME then
					local var0_13 = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_13[2])
					local var1_13 = pg.TimeMgr.GetInstance():GetServerTime()

					var9_11 = var9_11 and var0_13 <= var1_13
				elseif arg0_13[1] == ActivitySpStoryNode.CONDITION.PASSCHAPTER then
					local var2_13 = arg0_13[2]

					var9_11 = var9_11 and _.all(var2_13, function(arg0_14)
						return getProxy(ChapterProxy):getChapterById(arg0_14, true):isClear()
					end)
				elseif arg0_13[1] == ActivitySpStoryNode.CONDITION.PT then
					local var3_13 = arg0_13[2][1]
					local var4_13 = arg0_13[2][2]
					local var5_13 = arg0_13[2][3]
					local var6_13 = 0

					if var3_13 == DROP_TYPE_RESOURCE then
						var6_13 = getProxy(PlayerProxy):getRawData():getResource(arg0_13[2])
					elseif var3_13 == DROP_TYPE_ITEM then
						var6_13 = getProxy(BagProxy):getItemCountById(var4_13)
					end

					var9_11 = var9_11 and var5_13 <= var6_13
				end
			end)
		end

		if var12_11 then
			var10_11 = var4_0
		elseif var9_11 then
			var10_11 = var3_0
		end

		var3_11[var6_11].status = var10_11
	end

	arg0_11.storyNodeStatus = var3_11
	arg0_11.storyReadCount, arg0_11.storyReadMax = var0_11, var1_11
end

function var0_0.UpdateStory(arg0_15)
	arg0_15:RecyclePools()

	local var0_15 = {
		"43536c",
		"dbe7ea",
		"db6587"
	}
	local var1_15 = 0
	local var2_15 = 150
	local var3_15 = 150
	local var4_15 = arg0_15.nodeTplWidth
	local var5_15 = arg0_15.oneLineWidth
	local var6_15 = arg0_15.branchHeadWidth
	local var7_15 = arg0_15.branchUpWidth
	local var8_15 = arg0_15.branchUpHeight
	local var9_15 = arg0_15.UnionTailWidth
	local var10_15 = 95
	local var11_15 = 82
	local var12_15 = 20

	for iter0_15, iter1_15 in ipairs(arg0_15.nodeRootList) do
		local var13_15 = 0
		local var14_15 = {
			{
				node = iter1_15,
				nodePos = Vector2.New(var2_15, (iter0_15 - 1) * 400)
			}
		}

		local function var15_15()
			local var0_16 = table.remove(var14_15, 1)
			local var1_16 = var0_16.node:GetConfigID()

			;(function()
				local var0_17 = arg0_15:DequeItem(arg0_15.storyNodeTpl)

				var0_17.name = var1_16

				setAnchoredPosition(var0_17, var0_16.nodePos)

				arg0_15.storyNodeTFsById[var1_16] = {
					nodeTF = tf(var0_17)
				}
			end)()

			local var2_16 = arg0_15.nodeChildDict[var1_16] or {}

			if #var2_16 == 0 then
				var13_15 = var0_16.nodePos.x + var4_15 + var3_15
			elseif #var2_16 == 1 then
				local var3_16 = var2_16[1]
				local var4_16 = var3_16:GetConfigID()
				local var5_16 = arg0_15:DequeItem(arg0_15.oneLineTpl)

				var5_16.name = string.format("Line%s_%s", var1_16, var4_16)

				setAnchoredPosition(var5_16, var0_16.nodePos + Vector2.New(var4_15 + var12_15, 0))

				nextPos = tf(var5_16).anchoredPosition + Vector2.New(var5_15 + var10_15, 0)

				local var6_16 = arg0_15.storyNodeStatus[var4_16].status
				local var7_16 = tf(var5_16):Find("mask/Lines")

				eachChild(var7_16, function(arg0_18)
					setImageColor(arg0_18, Color.NewHex(var0_15[var6_16]))
				end)
				table.insert(var14_15, {
					node = var3_16,
					nodePos = nextPos
				})
			elseif #var2_16 > 1 then
				local var8_16 = {}
				local var9_16

				table.Ipairs(var2_16, function(arg0_19, arg1_19)
					local var0_19 = 0
					local var1_19 = arg1_19

					local function var2_19()
						var0_19 = var0_19 + 1

						local var0_20 = arg0_15.nodeChildDict[var1_19:GetConfigID()]

						assert(#var0_20 <= 1)

						local var1_20 = var0_20[1]

						if var1_20 and #var1_20:GetPreNodes() == 1 then
							var1_19 = var1_20

							return true
						else
							var9_16 = var1_20
						end
					end

					while var2_19() do
						-- block empty
					end

					var8_16[arg0_19] = var0_19
				end)

				local var10_16 = _.max(var8_16)
				local var11_16 = var10_16 * (var4_15 + var10_15 + var12_15) + (var10_16 - 1) * var5_15
				local var12_16 = var0_16.nodePos + Vector2.New(var4_15 + var12_15, 0)

				;(function()
					local var0_21 = arg0_15:DequeItem(arg0_15.branchHeadTpl)

					setAnchoredPosition(var0_21, var12_16)

					var12_16 = var12_16 + Vector2.New(var6_15, 0)

					local var1_21 = arg0_15.storyNodeStatus[var2_16[1]:GetConfigID()].status
					local var2_21 = tf(var0_21):Find("mask/Lines")

					eachChild(var2_21, function(arg0_22)
						setImageColor(arg0_22, Color.NewHex(var0_15[var1_21]))
					end)
				end)()
				table.Ipairs(var2_16, function(arg0_23, arg1_23)
					local var0_23 = var5_15

					if var8_16[arg0_23] < var10_16 then
						local var1_23 = var8_16[arg0_23]

						var0_23 = (var11_16 - var1_23 * (var4_15 + var10_15 + var12_15)) / (var1_23 + 1)
					end

					local var2_23 = arg1_23:GetConfigID()
					local var3_23 = var12_16

					;(function()
						local var0_24

						if arg0_23 == 1 then
							var0_24 = arg0_15:DequeItem(arg0_15.branchUpTpl)

							setAnchoredPosition(var0_24, var3_23)

							var3_23 = var3_23 + Vector2.New(var7_15, var8_15)

							if var8_16[arg0_23] < var10_16 then
								setSizeDelta(var0_24, {
									x = var7_15 + var0_23,
									y = var8_15
								})

								local var1_24 = tf(var0_24):Find("Line_1").sizeDelta

								var1_24.x = var1_24.x + var0_23

								setSizeDelta(tf(var0_24):Find("Line_1"), var1_24)

								var3_23 = var3_23 + Vector2.New(var0_23, 0)
							end
						elseif arg0_23 == 3 or arg0_23 == 2 and #var2_16 == 2 then
							var0_24 = arg0_15:DequeItem(arg0_15.branchDownTpl)

							setAnchoredPosition(var0_24, var3_23)

							var3_23 = var3_23 + Vector2.New(var7_15, -var8_15)

							if var8_16[arg0_23] < var10_16 then
								setSizeDelta(var0_24, {
									x = var7_15 + var0_23,
									y = var8_15
								})

								local var2_24 = tf(var0_24):Find("Line_1").sizeDelta

								var2_24.x = var2_24.x + var0_23

								setSizeDelta(tf(var0_24):Find("Line_1"), var2_24)

								var3_23 = var3_23 + Vector2.New(var0_23, 0)
							end
						else
							var0_24 = arg0_15:DequeItem(arg0_15.branchCenterTpl)

							setAnchoredPosition(var0_24, var3_23)

							var3_23 = var3_23 + Vector2.New(var7_15, 0)

							if var8_16[arg0_23] < var10_16 then
								local var3_24 = tf(var0_24).sizeDelta

								var3_24.x = var3_24.x + var0_23

								setSizeDelta(var0_24, var3_24)

								var3_23 = var3_23 + Vector2.New(var0_23, 0)
							end
						end

						var0_24.name = string.format("Branch%s_%s", var1_16, var2_23)

						local var4_24 = arg0_15.storyNodeStatus[var2_23].status
						local var5_24 = tf(var0_24):Find("mask/Lines")

						eachChild(var5_24, function(arg0_25)
							setImageColor(arg0_25, Color.NewHex(var0_15[var4_24]))
						end)
					end)()

					var3_23 = var3_23 + Vector2.New(var10_15, 0)

					local var4_23 = arg0_15:DequeItem(arg0_15.storyNodeTpl)

					var4_23.name = var2_23

					setAnchoredPosition(var4_23, var3_23)

					arg0_15.storyNodeTFsById[var2_23] = {
						nodeTF = tf(var4_23)
					}
					var3_23 = var3_23 + Vector2.New(var4_15 + var12_15, 0)

					local var5_23 = arg0_15.nodeChildDict[var2_23][1]
					local var6_23 = arg1_23

					local function var7_23()
						if not var5_23 or var5_23 == var9_16 then
							return
						end

						local var0_26 = arg0_15:DequeItem(arg0_15.oneLineTpl)

						var0_26.name = string.format("Line%s_%s", var6_23:GetConfigID(), var5_23:GetConfigID())

						setAnchoredPosition(var0_26, var3_23)

						var3_23 = var3_23 + Vector2.New(var0_23 + var10_15, 0)

						setSizeDelta(var0_26, {
							x = var0_23,
							y = arg0_15.oneLineHeight
						})

						local var1_26 = arg0_15.storyNodeStatus[var5_23:GetConfigID()].status
						local var2_26 = tf(var0_26):Find("mask/Lines")

						eachChild(var2_26, function(arg0_27)
							setImageColor(arg0_27, Color.NewHex(var0_15[var1_26]))
						end)

						local var3_26 = arg0_15:DequeItem(arg0_15.storyNodeTpl)

						var3_26.name = var5_23:GetConfigID()

						setAnchoredPosition(var3_26, var3_23)

						arg0_15.storyNodeTFsById[var5_23:GetConfigID()] = {
							nodeTF = tf(var3_26)
						}
						var3_23 = var3_23 + Vector2.New(var4_15 + var12_15, 0)
						var5_23, var6_23 = arg0_15.nodeChildDict[var5_23:GetConfigID()][1], var5_23

						return true
					end

					while var7_23() do
						-- block empty
					end

					if var9_16 then
						local var8_23

						if arg0_23 == 1 then
							var8_23 = arg0_15:DequeItem(arg0_15.unionUpTpl)

							setAnchoredPosition(var8_23, var3_23)

							if var8_16[arg0_23] < var10_16 then
								setSizeDelta(var8_23, {
									x = var7_15 + var0_23,
									y = var8_15
								})

								local var9_23 = tf(var8_23):Find("Line_1").sizeDelta

								var9_23.x = var9_23.x + var0_23

								setSizeDelta(tf(var8_23):Find("Line_1"), var9_23)

								var3_23 = var3_23 + Vector2.New(var0_23, 0)
							end
						elseif arg0_23 == 3 or arg0_23 == 2 and #var2_16 == 2 then
							var8_23 = arg0_15:DequeItem(arg0_15.unionDownTpl)

							setAnchoredPosition(var8_23, var3_23)

							if var8_16[arg0_23] < var10_16 then
								setSizeDelta(var8_23, {
									x = var7_15 + var0_23,
									y = var8_15
								})

								local var10_23 = tf(var8_23):Find("Line_1").sizeDelta

								var10_23.x = var10_23.x + var0_23

								setSizeDelta(tf(var8_23):Find("Line_1"), var10_23)

								var3_23 = var3_23 + Vector2.New(var0_23, 0)
							end
						else
							var8_23 = arg0_15:DequeItem(arg0_15.unionCenterTpl)

							setAnchoredPosition(var8_23, var3_23)

							if var8_16[arg0_23] < var10_16 then
								local var11_23 = tf(var8_23).sizeDelta

								var11_23.x = var11_23.x + var0_23

								setSizeDelta(var8_23, var11_23)

								var3_23 = var3_23 + Vector2.New(var0_23, 0)
							end
						end

						var8_23.name = string.format("Union%s_%s", var6_23:GetConfigID(), var9_16:GetConfigID())

						local var12_23 = arg0_15.storyNodeStatus[var9_16:GetConfigID()].status
						local var13_23 = tf(var8_23):Find("mask/Lines")

						eachChild(var13_23, function(arg0_28)
							setImageColor(arg0_28, Color.NewHex(var0_15[var12_23]))
						end)
					end
				end)

				var12_16 = var12_16 + Vector2.New(var11_16 + var7_15, 0)

				if var9_16 then
					(function()
						var12_16 = var12_16 + Vector2.New(var7_15, 0)

						local var0_29 = arg0_15:DequeItem(arg0_15.unionTailTpl)

						setAnchoredPosition(var0_29, var12_16)

						var12_16 = var12_16 + Vector2.New(var9_15 + var11_15, 0)

						local var1_29 = arg0_15.storyNodeStatus[var9_16:GetConfigID()].status
						local var2_29 = tf(var0_29):Find("mask/Lines")

						eachChild(var2_29, function(arg0_30)
							setImageColor(arg0_30, Color.NewHex(var0_15[var1_29]))
						end)
					end)()
					table.insert(var14_15, {
						node = var9_16,
						nodePos = var12_16
					})
				else
					var13_15 = var12_16 + var3_15
				end
			end

			return next(var14_15)
		end

		while var15_15() do
			-- block empty
		end

		var1_15 = math.max(var1_15, var13_15)
	end

	setSizeDelta(arg0_15.storyContainer, {
		x = var1_15
	})

	local var16_15 = arg0_15.spStoryNodes

	for iter2_15 = 1, #var16_15 do
		local var17_15 = var16_15[iter2_15]
		local var18_15 = var17_15:GetConfigID()
		local var19_15 = arg0_15.storyNodeStatus[var18_15].status
		local var20_15 = arg0_15.storyNodeTFsById[var18_15].nodeTF
		local var21_15 = var20_15:Find("info/bk/title_form/title")

		if var19_15 == var2_0 then
			setScrollText(var21_15, HXSet.hxLan(var17_15:GetUnlockDesc()))
			setTextAlpha(var21_15, 0.5)
		else
			setScrollText(var21_15, HXSet.hxLan(var17_15:GetDisplayName()))
			setTextAlpha(var21_15, 1)
		end

		local var22_15 = var17_15:GetType()

		setActive(var20_15:Find("circle/lock"), var19_15 == var2_0)

		if var19_15 == var2_0 then
			setActive(var20_15:Find("circle/Story"), false)
			setActive(var20_15:Find("circle/Battle"), false)
			setText(var20_15:Find(""))
		elseif var22_15 == ActivitySpStoryNode.NODE_TYPE.STORY then
			setActive(var20_15:Find("circle/Story"), var22_15 == ActivitySpStoryNode.NODE_TYPE.STORY)
			setActive(var20_15:Find("circle/Battle"), var22_15 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var20_15:Find("circle/Story/Done"), var19_15 == var4_0)
		elseif var22_15 == ActivitySpStoryNode.NODE_TYPE.BATTLE then
			setActive(var20_15:Find("circle/Story"), var22_15 == ActivitySpStoryNode.NODE_TYPE.STORY)
			setActive(var20_15:Find("circle/Battle"), var22_15 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
			setActive(var20_15:Find("circle/Battle/Done"), var19_15 == var4_0)
		end

		setActive(var20_15:Find("circle/bk/Inactive"), var19_15 == var2_0)
		setActive(var20_15:Find("circle/bk/Active"), var19_15 == var3_0)
		setActive(var20_15:Find("circle/bk/Readed"), var19_15 == var4_0)
		setActive(var20_15:Find("info/bk/BG/Inactive"), var19_15 == var2_0)
		setActive(var20_15:Find("info/bk/BG/Active"), var19_15 ~= var2_0)
		onButton(arg0_15, var20_15, function()
			if var19_15 == var2_0 then
				return
			end

			local var0_31 = var17_15:GetStoryName()

			arg0_15:PlayStory(var0_31, function()
				arg0_15:UpdateView()

				arg0_15.needFocusStory = true

				arg0_15:Move2UnlockStory()
			end, true)
		end)
	end

	local var23_15 = arg0_15.storyReadCount
	local var24_15 = arg0_15.storyReadMax

	setText(arg0_15.progressText, var23_15 .. "/" .. var24_15)
	setActive(arg0_15.storyAward, tobool(arg0_15.storyTask))

	if arg0_15.storyTask then
		local var25_15 = arg0_15.storyTask:getConfig("award_display")
		local var26_15 = Drop.New({
			type = var25_15[1][1],
			id = var25_15[1][2],
			count = var25_15[1][3]
		})

		updateDrop(arg0_15.storyAward:Find("IconTpl"), var26_15)

		local var27_15 = arg0_15.storyTask:getTaskStatus()

		setActive(arg0_15.storyAward:Find("get"), var27_15 == 1)
		setActive(arg0_15.storyAward:Find("got"), var27_15 == 2)
		onButton(arg0_15, arg0_15.storyAward, function()
			arg0_15.coreStoryPage:emit(BaseUI.ON_DROP, var26_15)
		end)
	end
end

function var0_0.DequeItem(arg0_34, arg1_34)
	local var0_34 = arg0_34.pools[arg1_34]:Dequeue()

	table.insert(arg0_34.activeItems, {
		template = arg1_34,
		active = var0_34
	})
	setActive(var0_34, true)
	setParent(var0_34, arg0_34.storyContainer)

	return var0_34
end

function var0_0.Move2UnlockStory(arg0_35)
	if not arg0_35.needFocusStory then
		return
	end

	arg0_35.needFocusStory = nil

	local var0_35 = arg0_35.spStoryNodes
	local var1_35

	for iter0_35 = #var0_35, 1, -1 do
		local var2_35 = var0_35[iter0_35]:GetConfigID()

		if arg0_35.storyNodeStatus[var2_35].status > var2_0 then
			var1_35 = var2_35

			break
		end
	end

	local var3_35 = arg0_35.storyNodeTFsById[var1_35].nodeTF
	local var4_35 = arg0_35.storyNodeTpl.rect.width
	local var5_35 = var3_35.anchoredPosition.x + var4_35 * 0.5 - arg0_35.storyContainer.parent.rect.width * 0.5
	local var6_35 = math.clamp(var5_35, 0, math.max(0, arg0_35.storyContainer.rect.width - arg0_35.storyContainer.parent.rect.width))

	setAnchoredPosition(arg0_35.storyContainer, {
		x = -var6_35
	})
end

function var0_0.SwitchStoryMapAndBGM(arg0_36)
	local var0_36 = arg0_36.activity:getConfig("config_client").default_background
	local var1_36 = arg0_36.activity:getConfig("config_client").default_bgm
	local var2_36
	local var3_36 = arg0_36.spStoryNodes

	for iter0_36 = 1, #var3_36 do
		local var4_36 = var3_36[iter0_36]
		local var5_36 = var4_36:GetConfigID()

		if arg0_36.storyNodeStatus[var5_36].status == var4_0 then
			local var6_36 = var4_36:GetCleanAnimator()

			var0_36 = var4_36:GetCleanBG() ~= "" and var4_36:GetCleanBG() or var0_36

			if var4_36:GetCleanBGM() ~= "" then
				var1_36 = var4_36:GetCleanBGM() or var1_36
			end
		else
			break
		end
	end

	if var0_36 ~= nil and var0_36 ~= "" then
		arg0_36.coreStoryPage:SwitchBG({
			{
				BG = var0_36
			}
		})
	end

	if var1_36 ~= nil and var1_36 ~= "" then
		pg.BgmMgr.GetInstance():Push(arg0_36.__cname, var1_36)
	end
end

function var0_0.TrySubmitTask(arg0_37)
	local var0_37 = true

	for iter0_37, iter1_37 in ipairs(arg0_37.spStoryNodes) do
		local var1_37 = iter1_37:GetStoryName()

		if var1_37 and var1_37 ~= "" then
			var0_37 = var0_37 and pg.NewStoryMgr.GetInstance():IsPlayed(var1_37)
		end

		if not var0_37 then
			break
		end
	end

	if var0_37 and arg0_37.storyTask and arg0_37.storyTask:getTaskStatus() == 1 then
		arg0_37.coreStoryPage:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_37.storyTask)

		return
	end
end

function var0_0.PlayStory(arg0_38, arg1_38, arg2_38, arg3_38)
	if not arg1_38 then
		return existCall(arg2_38)
	end

	local var0_38 = pg.NewStoryMgr.GetInstance()
	local var1_38 = var0_38:IsPlayed(arg1_38)

	seriesAsync({
		function(arg0_39)
			if var1_38 and not arg3_38 then
				return arg0_39()
			end

			local var0_39 = tonumber(arg1_38)

			if var0_39 and var0_39 > 0 then
				arg0_38.coreStoryPage:emit(ActivityMediator.GO_PERFORM_COMBAT, {
					stageId = var0_39
				})
			else
				var0_38:Play(arg1_38, arg0_39, arg3_38)
			end
		end,
		function(arg0_40, ...)
			existCall(arg2_38, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_41)
	local var0_41 = arg0_41.activity:getConfig("config_client").task_id
	local var1_41 = getProxy(TaskProxy):getTaskVO(var0_41)

	if not var1_41 then
		errorMsg("Missing Activity Task ID : " .. var0_41)
	end

	arg0_41.storyTask = var1_41 or Task.New({
		id = var0_41
	})
end

function var0_0.OnSubmitTaskDone(arg0_42)
	arg0_42:UpdateView()
end

function var0_0.OnDestroy(arg0_43)
	arg0_43:RecyclePools()

	for iter0_43, iter1_43 in pairs(arg0_43.pools) do
		iter1_43:Clear()
	end
end

return var0_0
