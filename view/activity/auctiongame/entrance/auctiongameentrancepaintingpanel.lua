local var0_0 = class("AuctionGameEntrancePaintingPanel", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.paintingDefaultAngle = arg0_2.uiPaintingTf.localEulerAngles

	arg0_2:SwitchDisplayPanel(true)

	arg0_2.paintingEventCom = GetComponent(arg0_2._tf, typeof(DftAniEvent))

	onButton(arg0_2, arg0_2.uiDisplayBtn, function()
		local var0_3 = {
			function(arg0_4)
				arg0_2:SwitchDisplayPanel(true)
				arg0_2.paintingEventCom:SetEndEvent(arg0_4)
				quickPlayAnimation(arg0_2._tf, "Anim_AuctionGameEntranceUI_leftPanel_in")
			end
		}

		seriesAsync(var0_3, function()
			return
		end)
	end)
	onButton(arg0_2, arg0_2.uiCollapseBtn, function()
		local var0_6 = {
			function(arg0_7)
				arg0_2.paintingEventCom:SetEndEvent(arg0_7)
				quickPlayAnimation(arg0_2._tf, "Anim_AuctionGameEntranceUI_leftPanel_out")
			end
		}

		seriesAsync(var0_6, function()
			arg0_2:SwitchDisplayPanel(false)
		end)
	end)
end

function var0_0.didEnter(arg0_9)
	local var0_9 = getProxy(PlayerProxy):getRawData():GetShipPhantomMarks()[1]

	arg0_9.shipVO = getProxy(BayProxy):GetShipPhantom(var0_9)

	arg0_9:RefreshPainting()
end

function var0_0.RefreshPainting(arg0_10)
	setPaintingPrefabAsync(arg0_10.uiPaintingTf, arg0_10:GetPaintingName(), "biandui", nil, {
		skinID = arg0_10.shipVO:getSkinId(),
		rotateZ = arg0_10.paintingDefaultAngle.z
	})
end

function var0_0.SwitchDisplayPanel(arg0_11, arg1_11)
	setActive(arg0_11.uiDisplayBtn, not arg1_11)
	setActive(arg0_11.uiPaintingPanel, arg1_11)
end

function var0_0.GetPaintingName(arg0_12)
	return (arg0_12.shipVO:getPainting())
end

function var0_0.willExit(arg0_13)
	arg0_13:detach()
	arg0_13.paintingEventCom:SetEndEvent(nil)
	retPaintingPrefab(arg0_13.uiPaintingTf, arg0_13:GetPaintingName())
end

return var0_0
