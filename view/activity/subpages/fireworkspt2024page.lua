local var0 = class("FireworksPt2024Page", import(".FireworksPtPage"))

var0.ANIM_SHOW = {
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

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.fireBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SPRING_FESTIVAL_BACKHILL_2024, {
			openFireworkLayer = true
		})
	end, SFX_PANEL)
end

function var0.UpdateFrieworkPanel(arg0, arg1)
	arg0.fireworkAct = getProxy(ActivityProxy):getActivityById(arg0.fireworkActID)

	assert(arg0.fireworkAct and not arg0.fireworkAct:isEnd(), "烟花活动(type92)已结束")

	arg0.unlockCount = arg0.fireworkAct:getData1()
	arg0.unlockIds = arg0.fireworkAct:getData1List()

	local var0 = #arg0.fireworkPages

	if var0 < arg1 or arg1 < 1 then
		return
	end

	arg0.pageIndex = arg1

	for iter0, iter1 in ipairs(arg0.fireworkPages) do
		setActive(iter1, tonumber(iter1.name) == arg1)
	end

	for iter2, iter3 in ipairs(arg0.dots) do
		setActive(iter3, tonumber(iter3.name) == arg1)
	end

	setButtonEnabled(arg0.nextPageBtn, arg1 ~= var0)
	setButtonEnabled(arg0.lastPageBtn, arg1 ~= 1)
	setText(arg0.fireworkNumText, #arg0.unlockIds .. "/" .. #arg0.fireworkIds)

	arg0.ptNum = getProxy(PlayerProxy):getRawData():getResource(arg0.ptID)

	setText(arg0.ptText, arg0.ptNum)

	local var1 = arg0:getAnimId()
	local var2 = arg0.unlockCount > 0 and arg0.ptNum >= arg0.ptConsume

	for iter4 = #arg0.fireworkPages, 1, -1 do
		eachChild(arg0.fireworkPages[iter4], function(arg0)
			local var0 = tonumber(arg0.name)

			if table.contains(arg0.unlockIds, var0) then
				setActive(arg0, false)
			else
				setActive(arg0, true)

				if var2 and var1 and var0 == var1 then
					arg0:playSwingAnim(arg0)
				else
					arg0:stopSwingAnim(arg0)
				end

				onButton(arg0, arg0, function()
					arg0:OnUnlockClick(var0)
				end, SFX_PANEL)
			end
		end)
	end
end

function var0.getAnimId(arg0)
	for iter0, iter1 in ipairs(var0.ANIM_SHOW[arg0.pageIndex]) do
		if not table.contains(arg0.unlockIds, iter1) then
			return iter1
		end
	end

	return nil
end

function var0.playSwingAnim(arg0, arg1)
	arg0:findTF("pos/Image", arg1):GetComponent(typeof(Animation)):Play("swing")
end

function var0.stopSwingAnim(arg0, arg1)
	arg0:findTF("pos/Image", arg1):GetComponent(typeof(Animation)):Stop()
end

return var0
