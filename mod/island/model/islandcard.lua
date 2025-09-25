local var0_0 = class("IslandCard")

var0_0.PHOTO_TYPE_ID = 1
var0_0.PHOTO_TYPE_ADDRESS = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.userId = arg1_1
	arg0_1.name = arg2_1.name
	arg0_1.photoStr = arg2_1.picture

	if arg0_1.photoStr == "" then
		local var0_1 = pg.island_set.island_card_photo_default.key_value_int

		arg0_1.photoStr = tostring(var0_1)
	end

	arg0_1.word = arg2_1.visit_word

	if arg0_1.word == "" then
		arg0_1.word = i18n("island_card_default_word")
	end

	arg0_1.level = arg2_1.lv
	arg0_1.socialFlag = arg2_1.social_flag
	arg0_1.labelFlag = arg2_1.label_view_flag
	arg0_1.labelData = {}

	for iter0_1, iter1_1 in ipairs(arg2_1.label_list or {}) do
		arg0_1.labelData[iter1_1.id] = iter1_1.num
	end

	arg0_1.achvList = arg2_1.achieve_list or {}
	arg0_1.achvCnt = arg2_1.achieve_num
	arg0_1.visitCnt = arg2_1.visit_num
	arg0_1.likeCnt = arg2_1.good_num
	arg0_1.shipCnt = arg2_1.ship_num
	arg0_1.bookCnt = arg2_1.book_num
	arg0_1.likeMark = arg2_1.good_flag == 1
	arg0_1.labelMark = arg2_1.label_flag == 1
	arg0_1.whiteMark = arg2_1.white_flag == 1
	arg0_1.blackMark = arg2_1.black_flag == 1
end

function var0_0.ShowLabel(arg0_2)
	return arg0_2.labelFlag == 1
end

function var0_0.GetLabelList(arg0_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in pairs(arg0_3.labelData) do
		table.insert(var0_3, {
			id = iter0_3,
			num = iter1_3
		})
	end

	return var0_3
end

function var0_0.AddLabel(arg0_4, arg1_4)
	local var0_4 = arg0_4.labelData[arg1_4] or 0

	arg0_4.labelData[arg1_4] = var0_4 + 1
end

function var0_0.ShowSocial(arg0_5)
	return arg0_5.socialFlag == 1
end

return var0_0
