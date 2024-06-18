local var0_0 = class("SixthAnniversaryJPHotSpringScene", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringScene"))

function var0_0.getUIName(arg0_1)
	return "SixthAnniversaryJPHotSpringUI"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
end

function var0_0.didEnter(arg0_3)
	var0_0.super.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("Top/Help"), function()
		MsgboxMediator.ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hotspring_help.tip,
			contextSprites = {
				{
					name = "wenquanshoupai",
					path = "props/wenquanshoupai"
				}
			}
		})
	end, SFX_PANEL)
	setImageSprite(arg0_3.top:Find("Ticket/Icon"), LoadSprite("props/wenquanshoupai", "wenquanshoupai"))
end

function var0_0.willExit(arg0_5)
	var0_0.super.willExit(arg0_5)
end

return var0_0
