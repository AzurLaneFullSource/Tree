local var0_0 = class("WSWorldInfo", import("...BaseEntity"))

var0_0.Fields = {
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
var0_0.Listeners = {
	onUpdate = "Update"
}

function var0_0.Build(arg0_1)
	pg.DelegateInfo.New(arg0_1)

	local var0_1 = nowWorld()

	var0_1:AddListener(World.EventUpdateGlobalBuff, arg0_1.onUpdate)
	var0_1:AddListener(World.EventAchieved, arg0_1.onUpdate)
	var0_1:GetAtlas():AddListener(WorldAtlas.EventAddPressingMap, arg0_1.onUpdate)
end

function var0_0.Dispose(arg0_2)
	local var0_2 = nowWorld()

	var0_2:RemoveListener(World.EventUpdateGlobalBuff, arg0_2.onUpdate)
	var0_2:RemoveListener(World.EventAchieved, arg0_2.onUpdate)
	var0_2:GetAtlas():RemoveListener(WorldAtlas.EventAddPressingMap, arg0_2.onUpdate)
	arg0_2:Clear()
	pg.DelegateInfo.Dispose(arg0_2)
end

function var0_0.Setup(arg0_3)
	arg0_3:Init()
	arg0_3:Update()
end

function var0_0.Init(arg0_4)
	arg0_4.powerIconTF = arg0_4.transform:Find("power/level")

	onToggle(arg0_4, arg0_4.powerIconTF, function(arg0_5)
		if arg0_5 and isActive(arg0_4.powerIconTF:Find("effect")) then
			local var0_5 = getProxy(PlayerProxy):getRawData()

			setActive(arg0_4.powerIconTF:Find("effect"), false)
			PlayerPrefs.SetInt("world_rank_icon_click_" .. var0_5.id, 1)
		end
	end)

	arg0_4.powerCount = arg0_4.transform:Find("power/bg/Number")
	arg0_4.buffListTF = arg0_4.transform:Find("buff")
	arg0_4.stepCount = arg0_4.transform:Find("explore/mileage/number")
	arg0_4.pressingCount = arg0_4.transform:Find("explore/pressing/number")
	arg0_4.btnAchievement = arg0_4.transform:Find("explore/achievement")

	onButton(arg0_4, arg0_4.btnAchievement, function()
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

	arg0_4.achievementCount = arg0_4.btnAchievement:Find("number")
	arg0_4.achievementTip = arg0_4.btnAchievement:Find("tip")
end

function var0_0.Update(arg0_7)
	local var0_7 = nowWorld()
	local var1_7 = var0_7:GetWorldRank()

	LoadImageSpriteAtlasAsync("ui/share/world_info_atlas", "level_phase_" .. var1_7, arg0_7.powerIconTF)

	local var2_7 = getProxy(PlayerProxy):getRawData()

	setActive(arg0_7.powerIconTF:Find("effect"), not PlayerPrefs.HasKey("world_rank_icon_click_" .. var2_7.id))
	setText(arg0_7.powerIconTF:Find("info/Text"), i18n("world_map_level", var1_7))
	setText(arg0_7.powerCount, var0_7:GetWorldPower())

	local var3_7 = var0_7:GetWorldMapBuffLevel()

	for iter0_7 = 1, 3 do
		setText(arg0_7.buffListTF:GetChild(iter0_7 - 1):Find("Text"), var3_7[iter0_7] or 0)
	end

	setText(arg0_7.stepCount, var0_7.stepCount)
	setText(arg0_7.pressingCount, var0_7:GetDisplayPressingCount())

	local var4_7, var5_7, var6_7 = var0_7:CountAchievements()

	setText(arg0_7.achievementCount, var4_7 + var5_7 .. "/" .. var6_7)

	local var7_7, var8_7 = var0_7:GetFinishAchievements(arg0_7.achEntranceList)

	setActive(arg0_7.achievementTip, #var7_7 > 0)
end

return var0_0
