local var0 = class("PuzzleActivity", import("model.vo.Activity"))

function var0.GetPicturePuzzleIds(arg0)
	local var0 = arg0.id
	local var1 = pg.activity_event_picturepuzzle[var0]

	assert(var1, "Can't Find activity_event_picturepuzzle 's ID : " .. (var0 or "NIL"))

	local var2 = Clone(var1.pickup_picturepuzzle)

	table.insertto(var2, var1.drop_picturepuzzle)

	return var2
end

return var0
