local var0_0 = class("PuzzleActivity", import("model.vo.Activity"))

function var0_0.GetPicturePuzzleIds(arg0_1)
	local var0_1 = arg0_1.id
	local var1_1 = pg.activity_event_picturepuzzle[var0_1]

	assert(var1_1, "Can't Find activity_event_picturepuzzle 's ID : " .. (var0_1 or "NIL"))

	local var2_1 = Clone(var1_1.pickup_picturepuzzle)

	table.insertto(var2_1, var1_1.drop_picturepuzzle)

	return var2_1
end

return var0_0
