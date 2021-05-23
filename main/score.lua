score = {}

function score:getBestScore()
	return sys.load(sys.get_save_file("sys_save_load", "bestScore")).bestScore or 0
end

function score:setBestScore(newBestScore)
	sys.save(sys.get_save_file("sys_save_load", "bestScore"), { bestScore = newBestScore })
end

return score