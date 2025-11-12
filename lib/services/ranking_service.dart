import '../models/idea.dart';
import '../models/profile.dart';
import '../models/realization.dart';

class RankingService {
  static int calculateIdeaPopularity(Idea idea) {
    int score = 0;
    score += idea.stealCount * 10;
    score += idea.fameScore * 5;
    score += idea.chain.length * 15;
    score += (idea.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 7))) ? 20 : 0);
    return score;
  }

  static int calculateThiefRespect(Profile thief) {
    int respect = 1;
    respect += (thief.stolenIdeasCount ~/ 5);
    respect += (thief.realizedCount ~/ 2);
    respect += (thief.totalFame ~/ 10);
    return respect.clamp(1, 10);
  }

  static int calculateRealizationScore(Realization realization) {
    int score = 0;
    score += realization.likes * 5;
    score += (realization.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 3))) ? 10 : 0);
    return score;
  }
}
