local var0_0 = class("WorldMediaCollectionAlbumGroupLayer", import(".WorldMediaCollectionSubLayer"))

var0_0.ALBUM_TYPE_BASE = 1
var0_0.ALBUM_TYPE_LOVE_LETTER = 2

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionAlbumGroupUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)

	arg0_2.albumGroups = _.map(pg.activity_medal_group.all, function(arg0_3)
		return pg.activity_medal_group[arg0_3]
	end)
	arg0_2.albumGroupList = arg0_2._tf:Find("GroupRect"):GetComponent("LScrollRect")

	function arg0_2.albumGroupList.onInitItem(arg0_4)
		arg0_2:onInitAlbumGroup(arg0_4)
	end

	function arg0_2.albumGroupList.onUpdateItem(arg0_5, arg1_5)
		arg0_2:onUpdateAlbumGroup(arg0_5 + 1, arg1_5)
	end

	arg0_2.albumGroupInfos = {}

	local var0_2 = tf(arg0_2.albumGroupList):Find("GroupItem")

	setActive(var0_2, false)

	arg0_2.albumGroupViewport = tf(arg0_2.albumGroupList):Find("Viewport")
	arg0_2.albumGroupsGrid = tf(arg0_2.albumGroupList):Find("Viewport/Content"):GetComponent(typeof(GridLayoutGroup))
	arg0_2.loader = AutoLoader.New()

	setText(arg0_2._tf:Find("top/expireCheckBox/text"), i18n("word_show_expire_content"))

	arg0_2.showExpireBtn = arg0_2._tf:Find("top/expireCheckBox/click")
	arg0_2.showExpireCheckBox = arg0_2._tf:Find("top/expireCheckBox/checkBox/check")
	arg0_2.showExpire = false

	setActive(arg0_2.showExpireCheckBox, arg0_2.showExpire)
	onButton(arg0_2, arg0_2.showExpireBtn, function()
		arg0_2.showExpire = not arg0_2.showExpire

		setActive(arg0_2.showExpireCheckBox, arg0_2.showExpire)
		arg0_2:ExpireFilter()
		arg0_2:UpdateView()
	end)

	arg0_2.rectAnchorX = arg0_2._tf:Find("GroupRect").anchoredPosition.x

	onToggle(arg0_2, arg0_2.toggleBase, function(arg0_7)
		if arg0_7 then
			arg0_2:SetPage(false)
		end
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.toggleLoveLetter, function(arg0_8)
		if arg0_8 then
			arg0_2:SetPage(true)
		end
	end, SFX_PANEL)

	arg0_2.initDic = {}
	arg0_2.cardItems = {}
	arg0_2.cardList = arg0_2.rtScrollRect:GetComponent("LScrollRect")

	function arg0_2.cardList.onInitItem(arg0_9)
		arg0_2:onInitCard(arg0_9)
	end

	function arg0_2.cardList.onUpdateItem(arg0_10, arg1_10)
		arg0_2:onUpdateCard(arg0_10, arg1_10)
	end

	function arg0_2.cardList.onReturnItem(arg0_11, arg1_11)
		arg0_2:onReturnCard(arg0_11, arg1_11)
	end

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_2.toggleLoveLetter:Find("tip"), {
		"love_letter_unlock_letter"
	}, function(arg0_12)
		setActive(arg0_12, getProxy(LoveLetterProxy):IsTipUnlockLetter())
	end)

	if arg0_2.contextData.albumType == var0_0.ALBUM_TYPE_LOVE_LETTER then
		triggerToggle(arg0_2.toggleLoveLetter, true)
	else
		triggerToggle(arg0_2.toggleBase, true)
	end
end

function var0_0.SetPage(arg0_13, arg1_13)
	setActive(arg0_13.rtGroupRect, not arg1_13)
	setActive(arg0_13.rtExpireCheckBox, not arg1_13)
	setActive(arg0_13.rtLoveLetterPanel, arg1_13)

	if not arg0_13.initDic[arg1_13] then
		switch(arg1_13, {
			[false] = function()
				arg0_13:ExpireFilter()
				arg0_13:UpdateView()
			end,
			[true] = function()
				arg0_13:updateLoveLetterPage()
			end
		}, nil)

		arg0_13.initDic[arg1_13] = true
	end
end

function var0_0.onInitAlbumGroup(arg0_16, arg1_16)
	if arg0_16.exited then
		return
	end

	onButton(arg0_16, arg1_16, function()
		local var0_17 = arg0_16.albumGroupInfos[arg1_16]

		if var0_17 then
			arg0_16.viewParent:ShowAlbum(var0_17)
		end
	end, SOUND_BACK)
end

function var0_0.onUpdateAlbumGroup(arg0_18, arg1_18, arg2_18)
	if arg0_18.exited then
		return
	end

	local var0_18 = arg0_18.albumGroups[arg1_18]

	arg0_18.albumGroupInfos[arg2_18] = var0_18

	arg0_18.loader:GetSpriteQuiet(var0_18.entrance_picture, "", tf(arg2_18):Find("BG"))

	local var1_18 = ActivityMedalGroup.IsMedalGroupCollectionGrey(var0_18.id) and ActivityMedalGroup.GetMedalGroupStateByID(var0_18.id) < ActivityMedalGroup.STATE_ACTIVE

	setActive(tf(arg2_18):Find("expireMask"), var1_18)
end

function var0_0.Return2MemoryGroup(arg0_19)
	local var0_19 = 0
	local var1_19 = arg0_19:GetIndexRatio(var0_19)

	arg0_19.albumGroupList:SetTotalCount(#arg0_19.albumGroups, var1_19)
end

function var0_0.SwitchReddotMemory(arg0_20)
	local var0_20 = 0
	local var1_20 = getProxy(PlayerProxy):getRawData().id

	for iter0_20, iter1_20 in ipairs(arg0_20.albumGroups) do
		if PlayerPrefs.GetInt("ALBUM_GROUP_NOTIFICATION" .. var1_20 .. " " .. iter1_20.id, 0) == 1 then
			var0_20 = iter0_20

			break
		end
	end

	if var0_20 == 0 then
		return
	end

	local var2_20 = arg0_20:GetIndexRatio(var0_20)

	arg0_20.albumGroupList:SetTotalCount(#arg0_20.albumGroups, var2_20)
end

function var0_0.GetIndexRatio(arg0_21, arg1_21)
	local var0_21 = 0

	if arg1_21 > 0 then
		local var1_21 = arg0_21.albumGroupList
		local var2_21 = arg0_21.albumGroupsGrid.cellSize.y + arg0_21.albumGroupsGrid.spacing.y
		local var3_21 = arg0_21.albumGroupsGrid.constraintCount
		local var4_21 = var2_21 * math.ceil(#arg0_21.albumGroups / var3_21)

		var0_21 = (var2_21 * math.floor((arg1_21 - 1) / var3_21) + var1_21.paddingFront) / (var4_21 - arg0_21.albumGroupViewport.rect.height)
		var0_21 = Mathf.Clamp01(var0_21)
	end

	return var0_21
end

function var0_0.ExpireFilter(arg0_22)
	local var0_22 = {}

	for iter0_22, iter1_22 in ipairs(pg.activity_medal_group.all) do
		local var1_22 = pg.activity_medal_group[iter1_22]
		local var2_22 = ActivityMedalGroup.GetMedalGroupStateByID(var1_22.id)

		if arg0_22.showExpire or var2_22 >= ActivityMedalGroup.STATE_ACTIVE then
			table.insert(var0_22, var1_22)
		end
	end

	arg0_22.albumGroups = var0_22
end

function var0_0.UpdateView(arg0_23)
	local var0_23 = WorldMediaCollectionScene.WorldRecordLock()

	setAnchoredPosition(arg0_23._tf:Find("GroupRect"), {
		x = var0_23 and 0 or arg0_23.rectAnchorX
	})
	arg0_23.albumGroupList:SetTotalCount(#arg0_23.albumGroups, 0)
end

function var0_0.updateLoveLetterPage(arg0_24)
	arg0_24.cardInfos = getProxy(LoveLetterProxy):GetDisplayLetterList()

	onDelayTick(function()
		arg0_24.cardList.enabled = true

		arg0_24.cardList:SetTotalCount(#arg0_24.cardInfos, 0)
	end, 0.001)
end

function var0_0.onInitCard(arg0_26, arg1_26)
	local var0_26 = LoveLetterShipCard.New(arg1_26)

	arg0_26.cardItems[arg1_26] = var0_26

	onButton(arg0_26, var0_26.go, function()
		if var0_26.shipGroup then
			arg0_26:emit(WorldMediaCollectionMediator.OPEN_LOVE_LETTER_DISPLAY, var0_26.shipGroup.id)
		end
	end)
end

function var0_0.onUpdateCard(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.cardItems[arg2_28]

	if not var0_28 then
		arg0_28:onInitCard(arg2_28)

		var0_28 = arg0_28.cardItems[arg2_28]
	end

	local var1_28 = arg1_28 + 1
	local var2_28 = arg0_28.cardInfos[var1_28]

	var0_28:update(var2_28)
	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg2_28.transform:Find("content/pick_up"), {
		"love_letter_unlock_letter"
	}, function(arg0_29)
		local var0_29 = getProxy(LoveLetterProxy):GetGroupData(var2_28.id)

		setActive(arg0_29, underscore.any(var0_29:GetDisplayLetterList(), function(arg0_30)
			return not var0_29:GetLetterUnlock(arg0_30)
		end))
	end)
end

function var0_0.onReturnCard(arg0_31, arg1_31, arg2_31)
	if arg0_31.exited then
		return
	end

	local var0_31 = arg0_31.cardItems[arg2_31]

	if var0_31 then
		var0_31:clear()
	end

	arg0_31.cardItems[arg2_31] = nil
end

function var0_0.OnDestroy(arg0_32)
	for iter0_32, iter1_32 in pairs(arg0_32.cardItems) do
		pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(iter0_32.transform:Find("content/pick_up"))
	end

	pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_32.toggleLoveLetter:Find("tip"))
end

return var0_0
