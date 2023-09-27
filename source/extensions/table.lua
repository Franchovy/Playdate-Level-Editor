function table.removevalue(t, value)
	for k, v in pairs(t) do
		if v == value then
			t[k] = nil
		end
	end
end