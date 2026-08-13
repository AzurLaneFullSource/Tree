local var0_0 = class("RapidSeasideMedalAlbumView", import(".MedalAlbumTemplateView"))

var0_0.GROUP_ID = 51113
var0_0.MEDAL_COUNT = 7
var0_0.ICON_SCALE = 1
var0_0.HELP_TIPS = "help_starLightAlbum"

function var0_0.getUIName(arg0_1)
	return "MedalAlbumRapidSeasidePage"
end

function var0_0.FindUI(arg0_2)
	local var0_2 = arg0_2._tf:Find("Top")

	arg0_2.bg = arg0_2._tf:Find("mask")
	arg0_2.backBtn = var0_2:Find("BackBtn")
	arg0_2.helpBtn = var0_2:Find("InfoBtn")
	arg0_2.taskBtn = arg0_2._tf:Find("Desk/taskBtn")
	arg0_2.prevBtn = arg0_2._tf:Find("Desk/prevBtn")
	arg0_2.nextBtn = arg0_2._tf:Find("Desk/nextBtn")
	arg0_2.slots = {}

	for iter0_2 = 1, arg0_2.MEDAL_COUNT do
		arg0_2.slots[iter0_2] = {
			slot = arg0_2._tf:Find("Desk/Slot" .. iter0_2),
			active = arg0_2._tf:Find("Desk/Slot" .. iter0_2 .. "/active"),
			tips = arg0_2._tf:Find("Desk/Slot" .. iter0_2 .. "/reddot"),
			click = arg0_2._tf:Find("Desk/Slot" .. iter0_2 .. "/Click")
		}
	end

	arg0_2.medalLock = arg0_2._tf:Find("Desk/medal")
	arg0_2.trophyLock = arg0_2._tf:Find("Desk/trophy")
	arg0_2.medalDetailView = DreamTourMedalDetailPanel.New(arg0_2._tf:Find("DetailView"), arg0_2)

	arg0_2.medalDetailView:SetIconScale(arg0_2.ICON_SCALE)

	arg0_2.medalTaskView = FujinBayMedalTaskPanel.New(arg0_2._tf:Find("TaskView"), arg0_2)
end

function var0_0.OwnTrophy(arg0_3)
	return getProxy(DormProxy):getData():GetOwnFurnitureCount(344) > 0
end

return var0_0
