local var0_0 = class("CoreScenarioTemplatePage", import("view.base.BaseSubView"))
local var1_0 = import("Mgr/Pool/PoolPlural")

var0_0.LINE_COLOR = {
	"43536c",
	"dbe7ea",
	"db6587"
}

function var0_0.getUIName(arg0_1)
	return "AEBCSScenarioPage"
end

function var0_0.OnInit(arg0_2)
	arg0_2.storyLayer = arg0_2._tf:Find("Story")
	arg0_2.top = arg0_2._tf:Find("TopPage")
	arg0_2.storyHolder = arg0_2._tf:Find("Story/Nodes")
	arg0_2.storyContainer = arg0_2.storyHolder:Find("Viewport/Content")
	arg0_2.nodes = {}
	arg0_2.progressText = arg0_2._tf:Find("TopPage/Desc/Text")
	arg0_2.storyAward = arg0_2._tf:Find("TopPage/Award")
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
	arg0_2.unreleasedNodeTpl = arg0_2._tf:Find("Story/UnreleasedNode")

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
	setActive(arg0_2.unreleasedNodeTpl, false)

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
		[arg0_2.unionDownTpl] = var1_0.New(go(arg0_2.unionDownTpl), 0),
		[arg0_2.unreleasedNodeTpl] = var1_0.New(go(arg0_2.unreleasedNodeTpl), 0)
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
	arg0_2.topPage = arg0_2._tf:Find("TopPage")
	arg0_2.backBtn = arg0_2._tf:Find("TopPage/top/btn_back")
	arg0_2.homeBtn = arg0_2._tf:Find("TopPage/top/btn_home")

	onButton(arg0_2, arg0_2.backBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.homeBtn, function()
		arg0_2.event:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	setText(arg0_2._tf:Find("TopPage/Desc/Desc"), i18n("series_enemy_storyreward"))
end

function var0_0.SetCoreStoryPage(arg0_5, arg1_5)
	arg0_5.coreStoryPage = arg1_5
end

function var0_0.SetActivity(arg0_6, arg1_6)
	arg0_6.activity = arg1_6

	arg0_6:BuildStoryTree()
end

function var0_0.BuildStoryTree(arg0_7)
	arg0_7.spStoryIDs = arg0_7.activity:getConfig("config_client").storys
	arg0_7.spStoryNodes = {}

	_.each(arg0_7.spStoryIDs, function(arg0_8)
		table.insert(arg0_7.spStoryNodes, ActivitySpStoryNode.New({
			configId = arg0_8
		}))
	end)

	arg0_7.nodeRootList, arg0_7.nodeChildDict = {}, {}

	_.each(arg0_7.spStoryNodes, function(arg0_9)
		local var0_9 = arg0_9:GetPreNodes()

		if #var0_9 == 0 then
			table.insert(arg0_7.nodeRootList, arg0_9)
		else
			_.each(var0_9, function(arg0_10)
				arg0_7.nodeChildDict[arg0_10] = arg0_7.nodeChildDict[arg0_10] or {}

				table.insert(arg0_7.nodeChildDict[arg0_10], arg0_9)
			end)
		end
	end)
end

function var0_0.IsShowRed(arg0_11, arg1_11)
	arg0_11:SetActivity(arg1_11)
	arg0_11:UpdateStoryNodeStatus()

	local var0_11 = false

	for iter0_11 = 1, #arg0_11.spStoryNodes do
		local var1_11 = arg0_11.spStoryNodes[iter0_11]

		arg0_11:checkRequireBlock(var1_11)

		if arg0_11.spStoryUnlockNode then
			var0_11 = true

			break
		end
	end

	arg0_11.spStoryUnlockNode = nil
	arg0_11.spStoryUnreleasedNode = nil

	return var0_11
end

function var0_0.UpdateView(arg0_12, arg1_12)
	arg0_12:UpdateStoryNodeStatus()
	arg0_12:UpdateStory(arg1_12)
	arg0_12:Move2UnlockStory()
	arg0_12:SwitchStoryMapAndBGM()
	setActive(arg0_12.storyLayer, true)
	arg0_12:TrySubmitTask()
end

function var0_0.RecyclePools(arg0_13)
	for iter0_13 = #arg0_13.activeItems, 1, -1 do
		local var0_13 = arg0_13.activeItems[iter0_13]
		local var1_13 = arg0_13.pools[var0_13.template]

		if var0_13.template == arg0_13.oneLineTpl then
			setSizeDelta(var0_13.active, {
				x = arg0_13.oneLineWidth,
				y = arg0_13.oneLineHeight
			})
		end

		var1_13:Enqueue(var0_13.active)
	end

	table.clean(arg0_13.activeItems)

	arg0_13.storyNodeTFsById = {}
end

local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.UpdateStoryNodeStatus(arg0_14)
	local var0_14 = 0
	local var1_14 = 0
	local var2_14 = pg.NewStoryMgr.GetInstance()
	local var3_14 = {}

	table.Foreach(arg0_14.spStoryIDs, function(arg0_15, arg1_15)
		var3_14[arg1_15] = {}
	end)

	local var4_14 = arg0_14.spStoryNodes

	for iter0_14 = 1, #var4_14 do
		local var5_14 = var4_14[iter0_14]
		local var6_14 = var5_14:GetConfigID()
		local var7_14 = var5_14:GetPreEvent()
		local var8_14 = true
		local var9_14 = var2_0
		local var10_14 = var5_14:GetStoryName()
		local var11_14 = false

		if var10_14 and var10_14 ~= "" then
			var11_14 = var2_14:IsPlayed(var10_14)
			var0_14 = var0_14 + (var11_14 and 1 or 0)
			var1_14 = var1_14 + 1
		end

		if not var11_14 then
			_.each(var5_14:GetUnlockConditions(), function(arg0_16)
				if arg0_16[1] == ActivitySpStoryNode.CONDITION.TIME then
					local var0_16 = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_16[2])
					local var1_16 = pg.TimeMgr.GetInstance():GetServerTime()

					var8_14 = var8_14 and var0_16 <= var1_16
				elseif arg0_16[1] == ActivitySpStoryNode.CONDITION.PASSCHAPTER then
					local var2_16 = arg0_16[2]

					var8_14 = var8_14 and _.all(var2_16, function(arg0_17)
						return getProxy(ChapterProxy):getChapterById(arg0_17, true):isClear()
					end)
				elseif arg0_16[1] == ActivitySpStoryNode.CONDITION.PT then
					local var3_16 = arg0_16[2][1]
					local var4_16 = arg0_16[2][2]
					local var5_16 = arg0_16[2][3]
					local var6_16 = 0

					if var3_16 == DROP_TYPE_RESOURCE then
						var6_16 = getProxy(PlayerProxy):getRawData():getResource(arg0_16[2][2])
					elseif var3_16 == DROP_TYPE_ITEM then
						var6_16 = getProxy(BagProxy):getItemCountById(var4_16)
					end

					var8_14 = var8_14 and var5_16 <= var6_16
					var3_14[var6_14].reuqire = var5_16
				elseif arg0_16[1] == ActivitySpStoryNode.CONDITION.PRE_PASSED then
					var8_14 = var3_14[var5_14:GetPreEvent()].status == var4_0
				end
			end)
		end

		if var11_14 then
			var9_14 = var4_0
		elseif var8_14 then
			var9_14 = var3_0
		end

		var3_14[var6_14].status = var9_14
	end

	arg0_14.storyNodeStatus = var3_14
	arg0_14.storyReadCount, arg0_14.storyReadMax = var0_14, var1_14
end

function var0_0.checkRequireBlock(arg0_18, arg1_18)
	local var0_18 = arg1_18:GetConfigID()
	local var1_18 = arg0_18.storyNodeStatus[var0_18]

	if var1_18.reuqire and var1_18.status ~= var4_0 and arg1_18:GetCleanAnimator() then
		if var1_18.status == var2_0 then
			arg0_18.spStoryUnreleasedNode = arg1_18

			return false
		elseif var1_18.status == var3_0 then
			local var2_18 = getProxy(PlayerProxy):getRawData().id

			if PlayerPrefs.GetInt("player_" .. var2_18 .. "_activity_spStoryNodeID_" .. var0_18 .. "_unlock", 0) == 0 then
				arg0_18.spStoryUnlockNode = arg1_18

				return false
			end
		end
	end

	return true
end

function var0_0.UpdateStory(arg0_19, arg1_19)
	arg0_19:RecyclePools()

	local var0_19 = arg0_19.LINE_COLOR
	local var1_19 = 0
	local var2_19 = 150
	local var3_19 = 150
	local var4_19 = arg0_19.nodeTplWidth
	local var5_19 = arg0_19.oneLineWidth
	local var6_19 = arg0_19.branchHeadWidth
	local var7_19 = arg0_19.branchUpWidth
	local var8_19 = arg0_19.branchUpHeight
	local var9_19 = arg0_19.UnionTailWidth
	local var10_19 = 95
	local var11_19 = 82
	local var12_19 = 20
	local var13_19 = 0
	local var14_19 = pg.NewStoryMgr.GetInstance()

	for iter0_19, iter1_19 in ipairs(arg0_19.nodeRootList) do
		local var15_19 = {
			{
				node = iter1_19,
				nodePos = Vector2.New(var2_19, (iter0_19 - 1) * 400)
			}
		}

		local function var16_19()
			local var0_20 = table.remove(var15_19, 1)
			local var1_20 = var0_20.node

			if not arg0_19:checkRequireBlock(var1_20) then
				var13_19 = var0_20.nodePos.x + var3_19

				return false
			end

			local var2_20 = var1_20:GetConfigID()

			;(function()
				local var0_21 = arg0_19:DequeItem(arg0_19.storyNodeTpl, arg1_19)

				var0_21.name = var2_20

				setAnchoredPosition(var0_21, var0_20.nodePos)

				arg0_19.storyNodeTFsById[var2_20] = {
					nodeTF = tf(var0_21)
				}
			end)()

			local var3_20 = arg0_19.nodeChildDict[var2_20] or {}

			if #var3_20 == 0 then
				var13_19 = var0_20.nodePos.x + var4_19 + var3_19
			elseif #var3_20 == 1 then
				local var4_20 = var3_20[1]
				local var5_20 = var4_20:GetConfigID()
				local var6_20 = arg0_19:DequeItem(arg0_19.oneLineTpl, arg1_19)

				var6_20.name = string.format("Line%s_%s", var2_20, var5_20)

				setAnchoredPosition(var6_20, var0_20.nodePos + Vector2.New(var4_19 + var12_19, 0))

				nextPos = tf(var6_20).anchoredPosition + Vector2.New(var5_19 + var10_19, 0)

				local var7_20 = arg0_19.storyNodeStatus[var5_20].status
				local var8_20 = tf(var6_20):Find("mask/Lines")

				eachChild(var8_20, function(arg0_22)
					setImageColor(arg0_22, Color.NewHex(var0_19[var7_20]))
				end)
				table.insert(var15_19, {
					node = var4_20,
					nodePos = nextPos
				})
			elseif #var3_20 > 1 then
				local var9_20 = {}
				local var10_20

				table.Ipairs(var3_20, function(arg0_23, arg1_23)
					local var0_23 = 0
					local var1_23 = arg1_23

					local function var2_23()
						var0_23 = var0_23 + 1

						local var0_24 = arg0_19.nodeChildDict[var1_23:GetConfigID()]

						assert(#var0_24 <= 1)

						local var1_24 = var0_24[1]

						if var1_24 and #var1_24:GetPreNodes() == 1 then
							var1_23 = var1_24

							return true
						else
							var10_20 = var1_24
						end
					end

					while var2_23() do
						-- block empty
					end

					var9_20[arg0_23] = var0_23
				end)

				local var11_20 = _.max(var9_20)
				local var12_20 = var11_20 * (var4_19 + var10_19 + var12_19) + (var11_20 - 1) * var5_19
				local var13_20 = var0_20.nodePos + Vector2.New(var4_19 + var12_19, 0)

				;(function()
					local var0_25 = arg0_19:DequeItem(arg0_19.branchHeadTpl, arg1_19)

					setAnchoredPosition(var0_25, var13_20)

					var13_20 = var13_20 + Vector2.New(var6_19, 0)

					local var1_25 = arg0_19.storyNodeStatus[var3_20[1]:GetConfigID()].status
					local var2_25 = tf(var0_25):Find("mask/Lines")

					eachChild(var2_25, function(arg0_26)
						setImageColor(arg0_26, Color.NewHex(var0_19[var1_25]))
					end)
				end)()

				local var14_20

				table.Ipairs(var3_20, function(arg0_27, arg1_27)
					local var0_27 = var5_19

					if var9_20[arg0_27] < var11_20 then
						local var1_27 = var9_20[arg0_27]

						var0_27 = (var12_20 - var1_27 * (var4_19 + var10_19 + var12_19)) / (var1_27 + 1)
					end

					local var2_27 = arg1_27:GetConfigID()
					local var3_27 = var13_20

					;(function()
						local var0_28

						if arg0_27 == 1 then
							var0_28 = arg0_19:DequeItem(arg0_19.branchUpTpl, arg1_19)

							setAnchoredPosition(var0_28, var3_27)

							var3_27 = var3_27 + Vector2.New(var7_19, var8_19)

							if var9_20[arg0_27] < var11_20 then
								setSizeDelta(var0_28, {
									x = var7_19 + var0_27,
									y = var8_19
								})

								local var1_28 = tf(var0_28):Find("Line_1").sizeDelta

								var1_28.x = var1_28.x + var0_27

								setSizeDelta(tf(var0_28):Find("Line_1"), var1_28)

								var3_27 = var3_27 + Vector2.New(var0_27, 0)
							end
						elseif arg0_27 == 3 or arg0_27 == 2 and #var3_20 == 2 then
							var0_28 = arg0_19:DequeItem(arg0_19.branchDownTpl, arg1_19)

							setAnchoredPosition(var0_28, var3_27)

							var3_27 = var3_27 + Vector2.New(var7_19, -var8_19)

							if var9_20[arg0_27] < var11_20 then
								setSizeDelta(var0_28, {
									x = var7_19 + var0_27,
									y = var8_19
								})

								local var2_28 = tf(var0_28):Find("Line_1").sizeDelta

								var2_28.x = var2_28.x + var0_27

								setSizeDelta(tf(var0_28):Find("Line_1"), var2_28)

								var3_27 = var3_27 + Vector2.New(var0_27, 0)
							end
						else
							var0_28 = arg0_19:DequeItem(arg0_19.branchCenterTpl, arg1_19)

							setAnchoredPosition(var0_28, var3_27)

							var3_27 = var3_27 + Vector2.New(var7_19, 0)

							if var9_20[arg0_27] < var11_20 then
								local var3_28 = tf(var0_28).sizeDelta

								var3_28.x = var3_28.x + var0_27

								setSizeDelta(var0_28, var3_28)

								var3_27 = var3_27 + Vector2.New(var0_27, 0)
							end
						end

						var0_28.name = string.format("Branch%s_%s", var2_20, var2_27)

						local var4_28 = arg0_19.storyNodeStatus[var2_27].status
						local var5_28 = tf(var0_28):Find("mask/Lines")

						eachChild(var5_28, function(arg0_29)
							setImageColor(arg0_29, Color.NewHex(var0_19[var4_28]))
						end)
					end)()

					var3_27 = var3_27 + Vector2.New(var10_19, 0)

					if not arg0_19:checkRequireBlock(arg1_27) then
						var13_19 = var3_27.x
						var14_20 = true

						return
					end

					local var4_27 = arg0_19:DequeItem(arg0_19.storyNodeTpl, arg1_19)

					var4_27.name = var2_27

					setAnchoredPosition(var4_27, var3_27)

					arg0_19.storyNodeTFsById[var2_27] = {
						nodeTF = tf(var4_27)
					}
					var3_27 = var3_27 + Vector2.New(var4_19 + var12_19, 0)

					local var5_27 = arg0_19.nodeChildDict[var2_27][1]
					local var6_27 = arg1_27

					local function var7_27()
						if not var5_27 or var5_27 == var10_20 then
							return
						end

						local var0_30 = arg0_19:DequeItem(arg0_19.oneLineTpl, arg1_19)

						var0_30.name = string.format("Line%s_%s", var6_27:GetConfigID(), var5_27:GetConfigID())

						setAnchoredPosition(var0_30, var3_27)

						var3_27 = var3_27 + Vector2.New(var0_27 + var10_19, 0)

						setSizeDelta(var0_30, {
							x = var0_27,
							y = arg0_19.oneLineHeight
						})

						local var1_30 = arg0_19.storyNodeStatus[var5_27:GetConfigID()].status
						local var2_30 = tf(var0_30):Find("mask/Lines")

						eachChild(var2_30, function(arg0_31)
							setImageColor(arg0_31, Color.NewHex(var0_19[var1_30]))
						end)

						if not arg0_19:checkRequireBlock(var5_27) then
							var13_19 = var3_27.x
							var14_20 = true

							return
						end

						local var3_30 = arg0_19:DequeItem(arg0_19.storyNodeTpl, arg1_19)

						var3_30.name = var5_27:GetConfigID()

						setAnchoredPosition(var3_30, var3_27)

						arg0_19.storyNodeTFsById[var5_27:GetConfigID()] = {
							nodeTF = tf(var3_30)
						}
						var3_27 = var3_27 + Vector2.New(var4_19 + var12_19, 0)
						var5_27, var6_27 = arg0_19.nodeChildDict[var5_27:GetConfigID()][1], var5_27

						return true
					end

					while var7_27() do
						-- block empty
					end

					if var10_20 then
						local var8_27

						if arg0_27 == 1 then
							var8_27 = arg0_19:DequeItem(arg0_19.unionUpTpl, arg1_19)

							setAnchoredPosition(var8_27, var3_27)

							if var9_20[arg0_27] < var11_20 then
								setSizeDelta(var8_27, {
									x = var7_19 + var0_27,
									y = var8_19
								})

								local var9_27 = tf(var8_27):Find("Line_1").sizeDelta

								var9_27.x = var9_27.x + var0_27

								setSizeDelta(tf(var8_27):Find("Line_1"), var9_27)

								var3_27 = var3_27 + Vector2.New(var0_27, 0)
							end
						elseif arg0_27 == 3 or arg0_27 == 2 and #var3_20 == 2 then
							var8_27 = arg0_19:DequeItem(arg0_19.unionDownTpl, arg1_19)

							setAnchoredPosition(var8_27, var3_27)

							if var9_20[arg0_27] < var11_20 then
								setSizeDelta(var8_27, {
									x = var7_19 + var0_27,
									y = var8_19
								})

								local var10_27 = tf(var8_27):Find("Line_1").sizeDelta

								var10_27.x = var10_27.x + var0_27

								setSizeDelta(tf(var8_27):Find("Line_1"), var10_27)

								var3_27 = var3_27 + Vector2.New(var0_27, 0)
							end
						else
							var8_27 = arg0_19:DequeItem(arg0_19.unionCenterTpl, arg1_19)

							setAnchoredPosition(var8_27, var3_27)

							if var9_20[arg0_27] < var11_20 then
								local var11_27 = tf(var8_27).sizeDelta

								var11_27.x = var11_27.x + var0_27

								setSizeDelta(var8_27, var11_27)

								var3_27 = var3_27 + Vector2.New(var0_27, 0)
							end
						end

						var8_27.name = string.format("Union%s_%s", var6_27:GetConfigID(), var10_20:GetConfigID())

						local var12_27 = arg0_19.storyNodeStatus[var10_20:GetConfigID()].status
						local var13_27 = tf(var8_27):Find("mask/Lines")

						eachChild(var13_27, function(arg0_32)
							setImageColor(arg0_32, Color.NewHex(var0_19[var12_27]))
						end)
					end
				end)

				if var14_20 then
					return false
				end

				var13_20 = var13_20 + Vector2.New(var12_20 + var7_19, 0)

				if var10_20 then
					(function()
						var13_20 = var13_20 + Vector2.New(var7_19, 0)

						local var0_33 = arg0_19:DequeItem(arg0_19.unionTailTpl, arg1_19)

						setAnchoredPosition(var0_33, var13_20)

						var13_20 = var13_20 + Vector2.New(var9_19 + var11_19, 0)

						local var1_33 = arg0_19.storyNodeStatus[var10_20:GetConfigID()].status
						local var2_33 = tf(var0_33):Find("mask/Lines")

						eachChild(var2_33, function(arg0_34)
							setImageColor(arg0_34, Color.NewHex(var0_19[var1_33]))
						end)
					end)()
					table.insert(var15_19, {
						node = var10_20,
						nodePos = var13_20
					})
				else
					var13_19 = var13_20 + var3_19
				end
			end

			return next(var15_19)
		end

		while var16_19() do
			-- block empty
		end

		var1_19 = math.max(var1_19, var13_19)
	end

	setSizeDelta(arg0_19.storyContainer, {
		x = var1_19
	})

	if arg0_19.spStoryUnreleasedNode or arg0_19.spStoryUnlockNode then
		local var17_19 = tf(arg0_19:DequeItem(arg0_19.unreleasedNodeTpl), arg1_19)

		setAnchoredPosition(var17_19, {
			y = 0,
			x = var13_19
		})

		local var18_19

		if arg0_19.spStoryUnreleasedNode then
			local var19_19 = arg0_19.storyNodeStatus[arg0_19.spStoryUnreleasedNode:GetConfigID()].reuqire

			setText(var17_19:Find("text"), i18n("scenario_unlock_pt_require", var19_19))

			var18_19 = arg0_19.spStoryUnreleasedNode:GetCleanAnimator()
		elseif arg0_19.spStoryUnlockNode then
			setText(var17_19:Find("text"), i18n("scenario_unlock"))

			local var20_19 = arg0_19.spStoryUnlockNode:GetConfigID()

			onButton(arg0_19, var17_19:Find("btn_unlock"), function()
				local var0_35 = getProxy(PlayerProxy):getRawData().id

				PlayerPrefs.SetInt("player_" .. var0_35 .. "_activity_spStoryNodeID_" .. var20_19 .. "_unlock", 1)
				arg0_19:UpdateView(true)

				arg0_19.needFocusStory = true

				arg0_19:Move2UnlockStory()
			end)

			var18_19 = arg0_19.spStoryUnlockNode:GetCleanAnimator()
		end

		ResourceMgr.Inst:getAssetAsync("ui/" .. var18_19, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_36)
			local var0_36 = Instantiate(arg0_36)
			local var1_36 = Vector3.New(-525, 0, 0)

			tf(var0_36).localPosition = var1_36

			setParent(var0_36, var17_19)
			WorldConst.ArrayEffectOrder(var17_19, 200)
		end), true, true)
	end

	arg0_19.spStoryUnreleasedNode = nil
	arg0_19.spStoryUnlockNode = nil

	local var21_19 = arg0_19.spStoryNodes

	for iter2_19 = 1, #var21_19 do
		local var22_19 = var21_19[iter2_19]
		local var23_19 = var22_19:GetConfigID()

		if arg0_19.storyNodeTFsById[var23_19] then
			local var24_19 = arg0_19.storyNodeStatus[var23_19].status
			local var25_19 = arg0_19.storyNodeTFsById[var23_19].nodeTF
			local var26_19 = var25_19:Find("info/bk/title_form/title")

			if var24_19 == var2_0 then
				setScrollText(var26_19, HXSet.hxLan(var22_19:GetUnlockDesc()))
				setTextAlpha(var26_19, 0.5)
			else
				setScrollText(var26_19, HXSet.hxLan(var22_19:GetDisplayName()))
				setTextAlpha(var26_19, 1)
			end

			local var27_19 = var22_19:GetType()

			setActive(var25_19:Find("circle/lock"), var24_19 == var2_0)

			if var24_19 == var2_0 then
				setActive(var25_19:Find("circle/Story"), false)
				setActive(var25_19:Find("circle/Battle"), false)
				setText(var25_19:Find(""))
			elseif var27_19 == ActivitySpStoryNode.NODE_TYPE.STORY then
				setActive(var25_19:Find("circle/Story"), var27_19 == ActivitySpStoryNode.NODE_TYPE.STORY)
				setActive(var25_19:Find("circle/Battle"), var27_19 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
				setActive(var25_19:Find("circle/Story/Done"), var24_19 == var4_0)
			elseif var27_19 == ActivitySpStoryNode.NODE_TYPE.BATTLE then
				setActive(var25_19:Find("circle/Story"), var27_19 == ActivitySpStoryNode.NODE_TYPE.STORY)
				setActive(var25_19:Find("circle/Battle"), var27_19 == ActivitySpStoryNode.NODE_TYPE.BATTLE)
				setActive(var25_19:Find("circle/Battle/Done"), var24_19 == var4_0)
			end

			setActive(var25_19:Find("circle/bk/Inactive"), var24_19 == var2_0)
			setActive(var25_19:Find("circle/bk/Active"), var24_19 == var3_0)
			setActive(var25_19:Find("circle/bk/Readed"), var24_19 == var4_0)
			setActive(var25_19:Find("info/bk/BG/Inactive"), var24_19 == var2_0)
			setActive(var25_19:Find("info/bk/BG/Active"), var24_19 ~= var2_0)
			onButton(arg0_19, var25_19, function()
				if var24_19 == var2_0 then
					return
				end

				local var0_37 = var22_19:GetStoryName()

				arg0_19:PlayStory(var0_37, function()
					arg0_19:UpdateView(true)

					arg0_19.needFocusStory = true

					arg0_19:Move2UnlockStory()
				end, true)
			end)
		end
	end

	local var28_19 = arg0_19.storyReadCount
	local var29_19 = arg0_19.storyReadMax

	setText(arg0_19.progressText, var28_19 .. "/" .. var29_19)
	setActive(arg0_19.storyAward, tobool(arg0_19.storyTask))

	if arg0_19.storyTask then
		local var30_19 = arg0_19.storyTask:getConfig("award_display")
		local var31_19 = Drop.New({
			type = var30_19[1][1],
			id = var30_19[1][2],
			count = var30_19[1][3]
		})

		updateDrop(arg0_19.storyAward:Find("IconTpl"), var31_19)

		local var32_19 = arg0_19.storyTask:getTaskStatus()

		setActive(arg0_19.storyAward:Find("get"), var32_19 == 1)
		setActive(arg0_19.storyAward:Find("got"), var32_19 == 2)
		onButton(arg0_19, arg0_19.storyAward, function()
			arg0_19.coreStoryPage:emit(BaseUI.ON_DROP, var31_19)
		end)
	end
end

function var0_0.DequeItem(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40.pools[arg1_40]:Dequeue()

	table.insert(arg0_40.activeItems, {
		template = arg1_40,
		active = var0_40
	})
	setActive(var0_40, true)
	setParent(var0_40, arg0_40.storyContainer)

	local var1_40 = var0_40:GetComponent(typeof(Animation))

	if var1_40 then
		var1_40.enabled = not arg2_40
	end

	return var0_40
end

function var0_0.Move2UnlockStory(arg0_41)
	if not arg0_41.needFocusStory then
		return
	end

	arg0_41.needFocusStory = nil

	local var0_41 = arg0_41.spStoryNodes
	local var1_41

	for iter0_41 = #var0_41, 1, -1 do
		local var2_41 = var0_41[iter0_41]
		local var3_41 = var2_41:GetConfigID()
		local var4_41 = arg0_41.storyNodeStatus[var3_41]

		if var4_41.status > var2_0 and (not var4_41.reuqire or not var2_41:GetCleanAnimator()) then
			var1_41 = var3_41

			break
		end
	end

	local var5_41 = arg0_41.storyNodeTFsById[var1_41].nodeTF
	local var6_41 = arg0_41.storyNodeTpl.rect.width
	local var7_41 = var5_41.anchoredPosition.x + var6_41 * 0.5 - arg0_41.storyContainer.parent.rect.width * 0.5
	local var8_41 = math.clamp(var7_41, 0, math.max(0, arg0_41.storyContainer.rect.width - arg0_41.storyContainer.parent.rect.width))

	setAnchoredPosition(arg0_41.storyContainer, {
		x = -var8_41
	})
end

function var0_0.SwitchStoryMapAndBGM(arg0_42)
	local var0_42 = arg0_42.activity:getConfig("config_client").default_background
	local var1_42 = arg0_42.activity:getConfig("config_client").default_bgm
	local var2_42
	local var3_42 = arg0_42.spStoryNodes

	for iter0_42 = 1, #var3_42 do
		local var4_42 = var3_42[iter0_42]
		local var5_42 = var4_42:GetConfigID()

		if arg0_42.storyNodeStatus[var5_42].status == var4_0 then
			local var6_42 = var4_42:GetCleanAnimator()

			var0_42 = var4_42:GetCleanBG() ~= "" and var4_42:GetCleanBG() or var0_42

			if var4_42:GetCleanBGM() ~= "" then
				var1_42 = var4_42:GetCleanBGM() or var1_42
			end
		else
			break
		end
	end

	if var0_42 ~= nil and var0_42 ~= "" then
		arg0_42.coreStoryPage:SwitchBG({
			{
				BG = var0_42
			}
		})
	end

	if var1_42 ~= nil and var1_42 ~= "" then
		pg.BgmMgr.GetInstance():Push(arg0_42.__cname, var1_42)
	end
end

function var0_0.TrySubmitTask(arg0_43)
	local var0_43 = true

	for iter0_43, iter1_43 in ipairs(arg0_43.spStoryNodes) do
		local var1_43 = iter1_43:GetStoryName()

		if var1_43 and var1_43 ~= "" then
			var0_43 = var0_43 and pg.NewStoryMgr.GetInstance():IsPlayed(var1_43)
		end

		if not var0_43 then
			break
		end
	end

	if var0_43 and arg0_43.storyTask and arg0_43.storyTask:getTaskStatus() == 1 then
		arg0_43.coreStoryPage:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_43.storyTask)

		return
	end
end

function var0_0.PlayStory(arg0_44, arg1_44, arg2_44, arg3_44)
	if not arg1_44 then
		return existCall(arg2_44)
	end

	local var0_44 = pg.NewStoryMgr.GetInstance()
	local var1_44 = var0_44:IsPlayed(arg1_44)

	seriesAsync({
		function(arg0_45)
			if var1_44 and not arg3_44 then
				return arg0_45()
			end

			local var0_45 = tonumber(arg1_44)

			if var0_45 and var0_45 > 0 then
				arg0_44.coreStoryPage:emit(ActivityMediator.GO_PERFORM_COMBAT, {
					stageId = var0_45
				})
			else
				var0_44:Play(arg1_44, arg0_45, arg3_44)
			end
		end,
		function(arg0_46, ...)
			existCall(arg2_44, ...)
		end
	})
end

function var0_0.UpdateStoryTask(arg0_47)
	local var0_47 = arg0_47.activity:getConfig("config_client").task_id
	local var1_47 = getProxy(TaskProxy):getTaskVO(var0_47)

	if not var1_47 then
		errorMsg("Missing Activity Task ID : " .. var0_47)
	end

	arg0_47.storyTask = var1_47 or Task.New({
		id = var0_47
	})
end

function var0_0.OnSubmitTaskDone(arg0_48)
	arg0_48:UpdateView()
end

function var0_0.Show(arg0_49)
	var0_0.super.Show(arg0_49)
	arg0_49:OverlayPanel(arg0_49._tf)
	arg0_49:OverlayPanel(arg0_49.topPage, {
		stopTop = true
	})
end

function var0_0.Hide(arg0_50)
	arg0_50:UnOverlayPanel(arg0_50.topPage, arg0_50._tf)
	arg0_50:UnOverlayPanel(arg0_50._tf, arg0_50._parentTf)
	var0_0.super.Hide(arg0_50)
end

function var0_0.OnDestroy(arg0_51)
	arg0_51:RecyclePools()

	for iter0_51, iter1_51 in pairs(arg0_51.pools) do
		iter1_51:Clear()
	end
end

return var0_0
