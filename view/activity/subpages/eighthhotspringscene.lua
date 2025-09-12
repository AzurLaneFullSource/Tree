local var0_0 = class("EighthHotSpringScene", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringScene"))

function var0_0.getUIName(arg0_1)
	return "EighthHotSpringUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
end

function var0_0.didEnter(arg0_3)
	var0_0.super.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("Top/Help"), function()
		MsgboxMediator.ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.eighth_tip_spring.tip,
			contextSprites = {
				{
					name = "eighthwenquanshoupai",
					path = "props/eighthwenquanshoupai"
				}
			}
		})
	end, SFX_PANEL)
	setImageSprite(arg0_3.top:Find("Ticket/Icon"), LoadSprite("props/eighthwenquanshoupai", "eighthwenquanshoupai"))
end

function var0_0.willExit(arg0_5)
	var0_0.super.willExit(arg0_5)
end

return var0_0
