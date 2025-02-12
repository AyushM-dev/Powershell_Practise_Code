Function Get-JarvisResponse() {
    <#
    .SYNOPSIS
    Jarvis is a lazy teenager. In conversation, his responses are very limited.
    
    .DESCRIPTION
    Jarvis is a lazy teenager. In conversation, his responses are very limited.
 
    Jarvis answers 'Sure.' if you ask him a question.
 
    He answers 'Whoa, chill out!' if you yell at him.
 
    He answers 'Calm down, I know what I'm doing!' if you yell a question at him.
 
    He says 'Fine. Be that way!' if you address him without actually saying
    anything.
 
    He answers 'Whatever.' to anything else.
    
    .PARAMETER HeyJarvis
    The sentence you say to Jarvis.
    
    .EXAMPLE
    Get-JarvisResponse -HeyJarvis "Hi Jarvis"
    #>
    [CmdletBinding()]
    Param(
        [string]$HeyJarvis
    )

    $TrimHeyJarvis = $HeyJarvis.Trim() #Removes spaces at start or end of string
    $question = $TrimHeyJarvis.EndsWith("?") #Check if ? exist at end of trimmed string
    $capsvalue = $TrimHeyJarvis -ceq $TrimHeyJarvis.ToUpper() -and $TrimHeyJarvis -match '[A-Za-z]' #Check if the string is all alphabetical and all caps

    # Check if string is null
    if ($TrimHeyJarvis -eq "") {
        return "Fine. Be that way!"
    }
    # Check if string is yelling a question
    elseif (($question) -and ($capsvalue)) {
        return "Calm down, I know what I'm doing!"
    }
    # Check if string is questioning
    elseif ($question) {
        return "Sure."
    }
    # Check if string is yelling
    elseif ($capsvalue) {
        return "Whoa, chill out!"
    }
    else {
        return "Whatever."
    }
}
