/**
 * Calculate a match score based on keyword presence in transcription.
 * 
 * @param transcription - The text to search within
 * @param keywords - Array of keywords to search for
 * @returns Score percentage (0-100) based on how many keywords are found
 */
export function calculateScore(transcription: string, keywords: string[]): number {
  // Handle edge cases
  if (!transcription || transcription.trim() === '' || keywords.length === 0) {
    return 0;
  }

  // Convert transcription to lowercase for case-insensitive matching
  const lowerTranscription = transcription.toLowerCase();
  
  // Use a Set for unique, lowercase keywords to optimize scoring
  const uniqueKeywords = [...new Set(keywords.map(k => k.toLowerCase()))];

  // Count how many unique keywords are found (as substrings)
  let matchCount = 0;
  for (const keyword of uniqueKeywords) {
    if (lowerTranscription.includes(keyword)) {
      matchCount++;
    }
  }

  // Calculate percentage score based on unique keywords
  const score = (matchCount / uniqueKeywords.length) * 100;
  
  return score;
}
