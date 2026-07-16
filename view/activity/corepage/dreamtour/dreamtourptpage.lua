local var0_0 = class("DreamTourPtPage", import("view.activity.CorePage.Helena.HelenaPtNewPage"))

local function var1_0(arg0_1)
	local var0_1 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()

	return (arg0_1._tf:Find("AD/rw/hx_ch" .. var0_1))
end

function var0_0.Hx4Channel(arg0_2)
	local var0_2 = var1_0(arg0_2)

	if not IsNil(var0_2) then
		setActive(var0_2, HXSet.isHx())
	end
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)
	arg0_3:Hx4Channel()
end

return var0_0
