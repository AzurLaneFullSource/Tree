local var0_0 = class("FireworksPt2024Page", import(".FireworksPtPage"))

var0_0.ANIM_SHOW = {
	{
		70166,
		70167,
		70165,
		70168,
		70169
	},
	{
		70170,
		70172,
		70171,
		70173,
		70174
	},
	{
		70175,
		70176,
		70177,
		70178
	}
}

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.fireBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SPRING_FESTIVAL_BACKHILL_2024, {
			openFireworkLayer = true
		})
	end, SFX_PANEL)
end

function var0_0.UpdateFrieworkPanel(arg0_3, arg1_3)
	arg0_3.fireworkAct = getProxy(ActivityProxy):getActivityById(arg0_3.fireworkActID)

	assert(arg0_3.fireworkAct and not arg0_3.fireworkAct:isEnd(), "烟花活动(type92)已结束")

	arg0_3.unlockCount = arg0_3.fireworkAct:getData1()
	arg0_3.unlockIds = arg0_3.fireworkAct:getData1List()

	local var0_3 = #arg0_3.fireworkPages

	if var0_3 < arg1_3 or arg1_3 < 1 then
		return
	end

	arg0_3.pageIndex = arg1_3

	for iter0_3, iter1_3 in ipairs(arg0_3.fireworkPages) do
		setActive(iter1_3, tonumber(iter1_3.name) == arg1_3)
	end

	for iter2_3, iter3_3 in ipairs(arg0_3.dots) do
		setActive(iter3_3, tonumber(iter3_3.name) == arg1_3)
	end

	setButtonEnabled(arg0_3.nextPageBtn, arg1_3 ~= var0_3)
	setButtonEnabled(arg0_3.lastPageBtn, arg1_3 ~= 1)
	setText(arg0_3.fireworkNumText, #arg0_3.unlockIds .. "/" .. #arg0_3.fireworkIds)

	arg0_3.ptNum = getProxy(PlayerProxy):getRawData():getResource(arg0_3.ptID)

	setText(arg0_3.ptText, arg0_3.ptNum)

	local var1_3 = arg0_3:getAnimId()
	local var2_3 = arg0_3.unlockCount > 0 and arg0_3.ptNum >= arg0_3.ptConsume

	for iter4_3 = #arg0_3.fireworkPages, 1, -1 do
		eachChild(arg0_3.fireworkPages[iter4_3], function(arg0_4)
			local var0_4 = tonumber(arg0_4.name)

			if table.contains(arg0_3.unlockIds, var0_4) then
				setActive(arg0_4, false)
			else
				setActive(arg0_4, true)

				if var2_3 and var1_3 and var0_4 == var1_3 then
					arg0_3:playSwingAnim(arg0_4)
				else
					arg0_3:stopSwingAnim(arg0_4)
				end

				onButton(arg0_3, arg0_4, function()
					arg0_3:OnUnlockClick(var0_4)
				end, SFX_PANEL)
			end
		end)
	end
end

function var0_0.getAnimId(arg0_6)
	for iter0_6, iter1_6 in ipairs(var0_0.ANIM_SHOW[arg0_6.pageIndex]) do
		if not table.contains(arg0_6.unlockIds, iter1_6) then
			return iter1_6
		end
	end

	return nil
end

function var0_0.playSwingAnim(arg0_7, arg1_7)
	arg0_7:findTF("pos/Image", arg1_7):GetComponent(typeof(Animation)):Play("swing")
end

function var0_0.stopSwingAnim(arg0_8, arg1_8)
	arg0_8:findTF("pos/Image", arg1_8):GetComponent(typeof(Animation)):Stop()
end

return var0_0
