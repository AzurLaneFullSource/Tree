local var0_0 = class("MassenaMedalAlbumView", import(".MedalAlbumTemplateView"))

var0_0.GROUP_ID = 50087
var0_0.MEDAL_COUNT = 8
var0_0.HELP_TIPS = "help_starLightAlbum"
var0_0.TASK_CLOSE_ANIM = "Anim_MedalAlbumMassenaPage_TaskView_Out"
var0_0.TASK_CLOSE_ANIM_Time = 0.12
var0_0.TASK_ANIM = "Anim_MedalAlbumMassenaPage_TaskView_TaskTpl_In"
var0_0.TASK_ENTER_ANIM_Time = 0.27
var0_0.TASK_Time = 0.08
var0_0.DETAIL_CLOSE_ANIM = "Anim_MedalAlbumMassenaPage_DetailView_Out"
var0_0.DETAIL_CLOSE_ANIM_Time = 0.1

function var0_0.getUIName(arg0_1)
	return "MedalAlbumMassenaPage"
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)
	onButton(arg0_2, arg0_2.backBtn, function()
		quickPlayAnimation(arg0_2._tf, "Anim_MedalAlbumMassenaPage_Out")
		onDelayTick(function()
			arg0_2:closeView()
		end, 0.1)
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.bg, function()
		quickPlayAnimation(arg0_2._tf, "Anim_MedalAlbumMassenaPage_Out")
		onDelayTick(function()
			arg0_2:closeView()
		end, 0.1)
	end, SFX_PANEL)
end

return var0_0
