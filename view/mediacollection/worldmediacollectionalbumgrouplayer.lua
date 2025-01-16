local var0_0 = class("WorldMediaCollectionAlbumGroupLayer", import(".WorldMediaCollectionSubLayer"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionAlbumGroupUI"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	assert(arg0_2.viewParent, "Need assign ViewParent for " .. arg0_2.__cname)

	arg0_2.albumGroups = _.map(pg.activity_medal_group.all, function(arg0_3)
		return pg.activity_medal_group[arg0_3]
	end)
	arg0_2.albumGroupList = arg0_2:findTF("GroupRect"):GetComponent("LScrollRect")

	function arg0_2.albumGroupList.onInitItem(arg0_4)
		arg0_2:onInitAlbumGroup(arg0_4)
	end

	function arg0_2.albumGroupList.onUpdateItem(arg0_5, arg1_5)
		arg0_2:onUpdateAlbumGroup(arg0_5 + 1, arg1_5)
	end

	arg0_2.albumGroupInfos = {}

	local var0_2 = arg0_2:findTF("GroupItem", arg0_2.albumGroupList)

	setActive(var0_2, false)

	arg0_2.albumGroupViewport = arg0_2:findTF("Viewport", arg0_2.albumGroupList)
	arg0_2.albumGroupsGrid = arg0_2:findTF("Viewport/Content", arg0_2.albumGroupList):GetComponent(typeof(GridLayoutGroup))
	arg0_2.loader = AutoLoader.New()

	setText(arg0_2:findTF("top/title/text"), i18n("word_limited_activity"))
	setText(arg0_2:findTF("top/expireCheckBox/text"), i18n("word_show_expire_content"))

	arg0_2.showExpireBtn = arg0_2:findTF("top/expireCheckBox/click")
	arg0_2.showExpireCheckBox = arg0_2:findTF("top/expireCheckBox/checkBox/check")
	arg0_2.showExpire = true

	onButton(arg0_2, arg0_2.showExpireBtn, function()
		arg0_2.showExpire = not arg0_2.showExpire

		arg0_2:ExpireFilter()
		arg0_2:UpdateView()
		setActive(arg0_2.showExpireCheckBox, arg0_2.showExpire)
	end)
	triggerButton(arg0_2.showExpireBtn)

	arg0_2.rectAnchorX = arg0_2:findTF("GroupRect").anchoredPosition.x

	arg0_2:UpdateView(arg0_2.showExpireBtn)
end

function var0_0.onInitAlbumGroup(arg0_7, arg1_7)
	if arg0_7.exited then
		return
	end

	onButton(arg0_7, arg1_7, function()
		local var0_8 = arg0_7.albumGroupInfos[arg1_7]

		if var0_8 then
			arg0_7.viewParent:ShowAlbum(var0_8)
		end
	end, SOUND_BACK)
end

function var0_0.onUpdateAlbumGroup(arg0_9, arg1_9, arg2_9)
	if arg0_9.exited then
		return
	end

	local var0_9 = arg0_9.albumGroups[arg1_9]

	arg0_9.albumGroupInfos[arg2_9] = var0_9

	arg0_9.loader:GetSpriteQuiet(var0_9.entrance_picture, "", tf(arg2_9):Find("BG"))
	setActive(tf(arg2_9):Find("expireMask"), ActivityMedalGroup.GetMedalGroupStateByID(var0_9.id) < ActivityMedalGroup.STATE_ACTIVE)
end

function var0_0.Return2MemoryGroup(arg0_10)
	local var0_10 = 0
	local var1_10 = arg0_10:GetIndexRatio(var0_10)

	arg0_10.albumGroupList:SetTotalCount(#arg0_10.albumGroups, var1_10)
end

function var0_0.SwitchReddotMemory(arg0_11)
	local var0_11 = 0
	local var1_11 = getProxy(PlayerProxy):getRawData().id

	for iter0_11, iter1_11 in ipairs(arg0_11.albumGroups) do
		if PlayerPrefs.GetInt("ALBUM_GROUP_NOTIFICATION" .. var1_11 .. " " .. iter1_11.id, 0) == 1 then
			var0_11 = iter0_11

			break
		end
	end

	if var0_11 == 0 then
		return
	end

	local var2_11 = arg0_11:GetIndexRatio(var0_11)

	arg0_11.albumGroupList:SetTotalCount(#arg0_11.albumGroups, var2_11)
end

function var0_0.GetIndexRatio(arg0_12, arg1_12)
	local var0_12 = 0

	if arg1_12 > 0 then
		local var1_12 = arg0_12.albumGroupList
		local var2_12 = arg0_12.albumGroupsGrid.cellSize.y + arg0_12.albumGroupsGrid.spacing.y
		local var3_12 = arg0_12.albumGroupsGrid.constraintCount
		local var4_12 = var2_12 * math.ceil(#arg0_12.albumGroups / var3_12)

		var0_12 = (var2_12 * math.floor((arg1_12 - 1) / var3_12) + var1_12.paddingFront) / (var4_12 - arg0_12.albumGroupViewport.rect.height)
		var0_12 = Mathf.Clamp01(var0_12)
	end

	return var0_12
end

function var0_0.ExpireFilter(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(pg.activity_medal_group.all) do
		local var1_13 = pg.activity_medal_group[iter1_13]
		local var2_13 = ActivityMedalGroup.GetMedalGroupStateByID(var1_13.id)

		if arg0_13.showExpire or var2_13 >= ActivityMedalGroup.STATE_ACTIVE then
			table.insert(var0_13, var1_13)
		end
	end

	arg0_13.albumGroups = var0_13
end

function var0_0.UpdateView(arg0_14)
	local var0_14 = WorldMediaCollectionScene.WorldRecordLock()

	setAnchoredPosition(arg0_14:findTF("GroupRect"), {
		x = var0_14 and 0 or arg0_14.rectAnchorX
	})
	arg0_14.albumGroupList:SetTotalCount(#arg0_14.albumGroups, 0)
end

return var0_0
