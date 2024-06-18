local var0_0 = class("HololiveMedalCollectionView", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "HololiveMedalCollectionUI"
end

function var0_0.init(arg0_2)
	arg0_2:InitData()
	arg0_2:FindUI()
	arg0_2:AddListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:UpdateView()
end

function var0_0.InitData(arg0_4)
	local var0_4 = getProxy(ActivityProxy)

	arg0_4.taskProxy = getProxy(TaskProxy)
	arg0_4.actMedal = var0_4:getActivityById(ActivityConst.HOLOLIVE_MEDAL_COLLECTION)
	arg0_4.allIDList = arg0_4.actMedal:getConfig("config_data")
	arg0_4.taskGroup = pg.activity_template[ActivityConst.HOLOLIVE_MEDAL_COLLECTION_TASK].config_data
	arg0_4.activatableIDList = arg0_4.actMedal.data1_list
	arg0_4.activeIDList = arg0_4.actMedal.data2_list
end

local var1_0 = {
	"mio",
	"fubuki",
	"matsuri",
	"sora",
	"shion",
	"aqua",
	"ayame",
	"purer",
	"tnt"
}
local var2_0 = {
	1,
	2,
	3,
	6,
	9,
	8,
	7,
	4,
	5
}

function var0_0.FindUI(arg0_5)
	arg0_5.bg = arg0_5:findTF("bg")
	arg0_5.top = arg0_5:findTF("top")
	arg0_5.backBtn = arg0_5:findTF("back", arg0_5.top)
	arg0_5.helpBtn = arg0_5:findTF("help", arg0_5.top)
	arg0_5.progressText = arg0_5:findTF("middle/board/progress")
	arg0_5.taskScroll = arg0_5:findTF("middle/board/Scroll View")
	arg0_5.taskScrollBar = arg0_5:findTF("middle/board/Scrollbar")
	arg0_5.taskListItems = CustomIndexLayer.Clone2Full(arg0_5.taskScroll:Find("Content"), #arg0_5.taskGroup)
	arg0_5.medalListItems = CustomIndexLayer.Clone2Full(arg0_5:findTF("middle/console/grid"), 9)
	arg0_5.medalImg = arg0_5:findTF("middle/console/slot"):GetComponent(typeof(Image))
	arg0_5.medalGet = arg0_5:findTF("middle/console/get")
	arg0_5.medalGot = arg0_5:findTF("middle/console/got")

	for iter0_5 = 1, #arg0_5.taskGroup do
		local var0_5 = LoadSprite("ui/HololiveMedalCollectionUI_atlas", var1_0[iter0_5])
		local var1_5 = arg0_5.taskListItems[iter0_5]:Find("icon"):GetComponent(typeof(Image))

		var1_5.sprite = var0_5
		var1_5.enabled = true

		local var2_5 = arg0_5.medalListItems[var2_0[iter0_5]]:Find("icon"):GetComponent(typeof(Image))

		var2_5.sprite = var0_5
		var2_5.enabled = true
	end

	arg0_5.materialGray = LoadAny("ui/HololiveMedalCollectionUI_atlas", "gray.mat")
end

function var0_0.AddListener(arg0_6)
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6:closeView()
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_dalaozhang.tip
		})
	end, SFX_PANEL)

	local var0_6 = arg0_6:findTF("middle/board/arrow")

	onScroll(arg0_6, arg0_6.taskScroll, function(arg0_9)
		setActive(var0_6, arg0_9.y > 0.001)
	end)
	onButton(arg0_6, arg0_6.medalGet, function()
		arg0_6:GetFinal()
	end, SFX_PANEL)
end

function var0_0.DataSetting(arg0_11)
	if #arg0_11.activatableIDList > 0 then
		local var0_11 = 1
		local var1_11

		while #arg0_11.activatableIDList >= 1 do
			local var2_11 = arg0_11.activatableIDList[var0_11]

			if not table.contains(arg0_11.activeIDList, var2_11) then
				var1_11 = var2_11

				break
			end

			var0_11 = var0_11 + 1
		end

		if var1_11 then
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = var1_11,
				actId = ActivityConst.HOLOLIVE_MEDAL_COLLECTION
			})

			return true
		end
	end
end

function var0_0.UpdateView(arg0_12)
	arg0_12:InitData()

	if arg0_12:DataSetting() then
		return
	end

	local var0_12 = #arg0_12.activeIDList == #arg0_12.allIDList and arg0_12.actMedal.data1 ~= 1
	local var1_12 = arg0_12.actMedal.data1 == 1
	local var2_12 = 0

	for iter0_12 = 1, #arg0_12.taskGroup do
		local var3_12 = arg0_12.taskListItems[iter0_12]
		local var4_12 = arg0_12.taskGroup[iter0_12]
		local var5_12 = arg0_12.taskProxy:getTaskVO(var4_12)
		local var6_12 = arg0_12:findTF("btn_go", var3_12)
		local var7_12 = arg0_12:findTF("btn_get", var3_12)
		local var8_12 = arg0_12:findTF("btn_got", var3_12)
		local var9_12 = table.contains(arg0_12.activeIDList, arg0_12.allIDList[iter0_12])
		local var10_12
		local var11_12 = 0

		if var5_12 then
			local var12_12 = var5_12:getProgress()
			local var13_12 = var5_12:getConfig("target_num")
			local var14_12 = var5_12:getConfig("desc")
			local var15_12 = string.gsub(var14_12, "$1", var12_12)
			local var16_12 = string.gsub(var15_12, "$2", var13_12)

			setText(arg0_12:findTF("desc", var3_12), var16_12)

			var11_12 = var5_12:getTaskStatus()
			var10_12 = var11_12 == 2 and arg0_12.materialGray or nil

			onButton(arg0_12, var6_12, function()
				arg0_12:emit(ActivityMediator.ON_TASK_GO, var5_12)
			end, SFX_PANEL)
			onButton(arg0_12, var7_12, function()
				arg0_12:emit(ActivityMediator.ON_TASK_SUBMIT, var5_12)
			end, SFX_PANEL)
		else
			local var17_12 = pg.task_data_template[var4_12].target_num
			local var18_12 = var9_12 and var17_12 or 0
			local var19_12 = pg.task_data_template[var4_12].desc
			local var20_12 = string.gsub(var19_12, "$1", var18_12)
			local var21_12 = string.gsub(var20_12, "$2", var17_12)

			setText(arg0_12:findTF("desc", var3_12), var21_12)

			var11_12 = var9_12 and 2 or 0
			var10_12 = arg0_12.materialGray

			onButton(arg0_12, var6_12, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			end, SFX_PANEL)
		end

		setActive(var6_12, var11_12 == 0)
		setActive(var7_12, var11_12 == 1)
		setActive(var8_12, var11_12 == 2)

		var3_12:GetComponent(typeof(Image)).material = var10_12
		var3_12:Find("icon"):GetComponent(typeof(Image)).material = var10_12

		local var22_12 = arg0_12.medalListItems[var2_0[iter0_12]]:Find("icon"):GetComponent(typeof(Image))

		var22_12.enabled = var9_12
		var22_12.material = var1_12 and arg0_12.materialGray or nil
		var2_12 = var2_12 + (var11_12 == 2 and 1 or 0)
	end

	setText(arg0_12.progressText, var2_12 .. "/9")

	arg0_12.medalImg.material = not var0_12 and not var1_12 and arg0_12.materialGray

	setActive(arg0_12.medalGet, var0_12)
	setActive(arg0_12.medalGot, var1_12)
end

function var0_0.GetFinal(arg0_16)
	if #arg0_16.activeIDList == #arg0_16.allIDList and arg0_16.actMedal.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = ActivityConst.HOLOLIVE_MEDAL_COLLECTION
		})
	end
end

function var0_0.PlayStory(arg0_17, arg1_17)
	local var0_17 = arg0_17.actMedal:getConfig("config_client").story

	if var0_17 then
		pg.NewStoryMgr.GetInstance():Play(var0_17, arg1_17)
	else
		arg1_17()
	end
end

function var0_0.IsTip()
	local var0_18 = getProxy(ActivityProxy)
	local var1_18 = getProxy(TaskProxy)
	local var2_18 = var0_18:getActivityById(ActivityConst.HOLOLIVE_MEDAL_COLLECTION)

	if var2_18 and not var2_18:isEnd() then
		local var3_18 = var2_18:getConfig("config_data")
		local var4_18 = pg.activity_template[ActivityConst.HOLOLIVE_MEDAL_COLLECTION_TASK].config_data
		local var5_18 = var2_18.data1_list
		local var6_18 = var2_18.data2_list

		for iter0_18, iter1_18 in ipairs(var4_18) do
			local var7_18 = var4_18[iter0_18]
			local var8_18 = var1_18:getTaskVO(var7_18)

			if var8_18 and var8_18:getTaskStatus() == 1 then
				return true
			end
		end

		for iter2_18, iter3_18 in ipairs(var5_18) do
			if not table.contains(var6_18, iter3_18) then
				return true
			end
		end

		if #var6_18 == #var3_18 and var2_18.data1 ~= 1 then
			return true
		end
	end
end

return var0_0
