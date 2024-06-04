local var0 = class("SixthAnniversaryJPHotSpringScene", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringScene"))

function var0.getUIName(arg0)
	return "SixthAnniversaryJPHotSpringUI"
end

function var0.init(arg0)
	var0.super.init(arg0)
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("Top/Help"), function()
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
	setImageSprite(arg0.top:Find("Ticket/Icon"), LoadSprite("props/wenquanshoupai", "wenquanshoupai"))
end

function var0.willExit(arg0)
	var0.super.willExit(arg0)
end

return var0
