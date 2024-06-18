local var0_0 = class("WSPortTask", import("...BaseEntity"))

var0_0.Fields = {
	btnOnGoing = "userdata",
	txDesc = "userdata",
	onDrop = "function",
	transform = "userdata",
	task = "table",
	rtType = "userdata",
	progress = "userdata",
	onButton = "function",
	rtRarity = "userdata",
	timer = "number",
	rtName = "userdata",
	txProgress = "userdata",
	btnFinished = "userdata",
	btnInactive = "userdata",
	rfAwardPanle = "userdata",
	rfItemTpl = "userdata"
}
var0_0.Listeners = {
	onTaskUpdate = "OnTaskUpdate"
}

function var0_0.Build(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init(arg1_1)
end

function var0_0.Dispose(arg0_2)
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.Init(arg0_3, arg1_3)
	arg0_3.transform = arg1_3
	arg0_3.rtType = arg1_3:Find("type")
	arg0_3.rtRarity = arg1_3:Find("rarity")
	arg0_3.rtName = arg1_3:Find("name")
	arg0_3.txDesc = arg1_3:Find("desc")
	arg0_3.btnInactive = arg1_3:Find("button/inactive")
	arg0_3.btnOnGoing = arg1_3:Find("button/ongoing")
	arg0_3.btnFinished = arg1_3:Find("button/finished")
	arg0_3.progress = arg1_3:Find("name/slider")
	arg0_3.txProgress = arg1_3:Find("name/slider_progress")
	arg0_3.rfAwardPanle = arg1_3:Find("award_panel/content")
	arg0_3.rfItemTpl = arg1_3:Find("item_tpl")
end

function var0_0.Setup(arg0_4, arg1_4)
	arg0_4.task = arg1_4

	arg0_4:OnTaskUpdate()
end

function var0_0.OnTaskUpdate(arg0_5)
	setImageColor(arg0_5.rtName, arg0_5.task.config.type == 5 and Color(0.0588235294117647, 0.0784313725490196, 0.109803921568627, 0.3) or Color(0.545098039215686, 0.596078431372549, 0.819607843137255, 0.3))
	setText(arg0_5.rtName:Find("Text"), arg0_5.task.config.name)
	setText(arg0_5.txDesc, arg0_5.task.config.description)
	GetImageSpriteFromAtlasAsync("ui/worldportui_atlas", pg.WorldToastMgr.Type2PictrueName[arg0_5.task.config.type], arg0_5.rtType, true)
	GetImageSpriteFromAtlasAsync("ui/worldportui_atlas", "rarity_" .. arg0_5.task.config.rank, arg0_5.rtRarity, true)

	local var0_5 = arg0_5.task.config.show

	removeAllChildren(arg0_5.rfAwardPanle)

	for iter0_5, iter1_5 in ipairs(var0_5) do
		local var1_5 = cloneTplTo(arg0_5.rfItemTpl, arg0_5.rfAwardPanle)
		local var2_5 = {
			type = iter1_5[1],
			id = iter1_5[2],
			count = iter1_5[3]
		}

		updateDrop(var1_5, var2_5)
		onButton(arg0_5, var1_5, function()
			arg0_5.onDrop(var2_5)
		end, SFX_PANEL)
		setActive(var1_5, true)
	end

	setActive(arg0_5.rfItemTpl, false)

	local var3_5 = arg0_5.task:getState()

	setActive(arg0_5.btnInactive, var3_5 == WorldTask.STATE_INACTIVE)
	setActive(arg0_5.btnOnGoing, var3_5 == WorldTask.STATE_ONGOING)
	setActive(arg0_5.btnFinished, var3_5 == WorldTask.STATE_FINISHED)
	setActive(arg0_5.txProgress, false)
	setActive(arg0_5.progress, false)
end

return var0_0
