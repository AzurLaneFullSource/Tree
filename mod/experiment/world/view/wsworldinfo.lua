local var0 = class("WSWorldInfo", import("...BaseEntity"))

var0.Fields = {
	powerCount = "userdata",
	stepCount = "userdata",
	achievementTip = "userdata",
	transform = "userdata",
	btnAchievement = "userdata",
	achievementCount = "userdata",
	powerIconTF = "userdata",
	buffListTF = "userdata",
	pressingCount = "userdata"
}
var0.Listeners = {
	onUpdate = "Update"
}

function var0.Build(arg0)
	pg.DelegateInfo.New(arg0)

	local var0 = nowWorld()

	var0:AddListener(World.EventUpdateGlobalBuff, arg0.onUpdate)
	var0:AddListener(World.EventAchieved, arg0.onUpdate)
	var0:GetAtlas():AddListener(WorldAtlas.EventAddPressingMap, arg0.onUpdate)
end

function var0.Dispose(arg0)
	local var0 = nowWorld()

	var0:RemoveListener(World.EventUpdateGlobalBuff, arg0.onUpdate)
	var0:RemoveListener(World.EventAchieved, arg0.onUpdate)
	var0:GetAtlas():RemoveListener(WorldAtlas.EventAddPressingMap, arg0.onUpdate)
	arg0:Clear()
	pg.DelegateInfo.Dispose(arg0)
end

function var0.Setup(arg0)
	arg0:Init()
	arg0:Update()
end

function var0.Init(arg0)
	arg0.powerIconTF = arg0.transform:Find("power/level")

	onToggle(arg0, arg0.powerIconTF, function(arg0)
		if arg0 and isActive(arg0.powerIconTF:Find("effect")) then
			local var0 = getProxy(PlayerProxy):getRawData()

			setActive(arg0.powerIconTF:Find("effect"), false)
			PlayerPrefs.SetInt("world_rank_icon_click_" .. var0.id, 1)
		end
	end)

	arg0.powerCount = arg0.transform:Find("power/bg/Number")
	arg0.buffListTF = arg0.transform:Find("buff")
	arg0.stepCount = arg0.transform:Find("explore/mileage/number")
	arg0.pressingCount = arg0.transform:Find("explore/pressing/number")
	arg0.btnAchievement = arg0.transform:Find("explore/achievement")

	onButton(arg0, arg0.btnAchievement, function()
		pg.m02:sendNotification(WorldMediator.OnNotificationOpenLayer, {
			context = Context.New({
				mediator = WorldCollectionMediator,
				viewComponent = WorldCollectionLayer,
				data = {
					page = WorldCollectionLayer.PAGE_ACHIEVEMENT,
					entranceId = nowWorld():GetActiveEntrance().id
				}
			})
		})
	end, SFX_PANEL)

	arg0.achievementCount = arg0.btnAchievement:Find("number")
	arg0.achievementTip = arg0.btnAchievement:Find("tip")
end

function var0.Update(arg0)
	local var0 = nowWorld()
	local var1 = var0:GetWorldRank()

	LoadImageSpriteAtlasAsync("ui/share/world_info_atlas", "level_phase_" .. var1, arg0.powerIconTF)

	local var2 = getProxy(PlayerProxy):getRawData()

	setActive(arg0.powerIconTF:Find("effect"), not PlayerPrefs.HasKey("world_rank_icon_click_" .. var2.id))
	setText(arg0.powerIconTF:Find("info/Text"), i18n("world_map_level", var1))
	setText(arg0.powerCount, var0:GetWorldPower())

	local var3 = var0:GetWorldMapBuffLevel()

	for iter0 = 1, 3 do
		setText(arg0.buffListTF:GetChild(iter0 - 1):Find("Text"), var3[iter0] or 0)
	end

	setText(arg0.stepCount, var0.stepCount)
	setText(arg0.pressingCount, var0:GetDisplayPressingCount())

	local var4, var5, var6 = var0:CountAchievements()

	setText(arg0.achievementCount, var4 + var5 .. "/" .. var6)

	local var7, var8 = var0:GetFinishAchievements(arg0.achEntranceList)

	setActive(arg0.achievementTip, #var7 > 0)
end

return var0
