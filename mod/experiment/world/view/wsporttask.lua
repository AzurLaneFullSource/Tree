local var0 = class("WSPortTask", import("...BaseEntity"))

var0.Fields = {
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
var0.Listeners = {
	onTaskUpdate = "OnTaskUpdate"
}

function var0.Build(arg0, arg1)
	pg.DelegateInfo.New(arg0)
	arg0:Init(arg1)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

function var0.Init(arg0, arg1)
	arg0.transform = arg1
	arg0.rtType = arg1:Find("type")
	arg0.rtRarity = arg1:Find("rarity")
	arg0.rtName = arg1:Find("name")
	arg0.txDesc = arg1:Find("desc")
	arg0.btnInactive = arg1:Find("button/inactive")
	arg0.btnOnGoing = arg1:Find("button/ongoing")
	arg0.btnFinished = arg1:Find("button/finished")
	arg0.progress = arg1:Find("name/slider")
	arg0.txProgress = arg1:Find("name/slider_progress")
	arg0.rfAwardPanle = arg1:Find("award_panel/content")
	arg0.rfItemTpl = arg1:Find("item_tpl")
end

function var0.Setup(arg0, arg1)
	arg0.task = arg1

	arg0:OnTaskUpdate()
end

function var0.OnTaskUpdate(arg0)
	setImageColor(arg0.rtName, arg0.task.config.type == 5 and Color(0.0588235294117647, 0.0784313725490196, 0.109803921568627, 0.3) or Color(0.545098039215686, 0.596078431372549, 0.819607843137255, 0.3))
	setText(arg0.rtName:Find("Text"), arg0.task.config.name)
	setText(arg0.txDesc, arg0.task.config.description)
	GetImageSpriteFromAtlasAsync("ui/worldportui_atlas", pg.WorldToastMgr.Type2PictrueName[arg0.task.config.type], arg0.rtType, true)
	GetImageSpriteFromAtlasAsync("ui/worldportui_atlas", "rarity_" .. arg0.task.config.rank, arg0.rtRarity, true)

	local var0 = arg0.task.config.show

	removeAllChildren(arg0.rfAwardPanle)

	for iter0, iter1 in ipairs(var0) do
		local var1 = cloneTplTo(arg0.rfItemTpl, arg0.rfAwardPanle)
		local var2 = {
			type = iter1[1],
			id = iter1[2],
			count = iter1[3]
		}

		updateDrop(var1, var2)
		onButton(arg0, var1, function()
			arg0.onDrop(var2)
		end, SFX_PANEL)
		setActive(var1, true)
	end

	setActive(arg0.rfItemTpl, false)

	local var3 = arg0.task:getState()

	setActive(arg0.btnInactive, var3 == WorldTask.STATE_INACTIVE)
	setActive(arg0.btnOnGoing, var3 == WorldTask.STATE_ONGOING)
	setActive(arg0.btnFinished, var3 == WorldTask.STATE_FINISHED)
	setActive(arg0.txProgress, false)
	setActive(arg0.progress, false)
end

return var0
