using System.ComponentModel;

namespace Bot_Server_WinForms
{
    public class ClientViewModel
    {
        public string Name { get; set; }

        [DisplayName("War Supplies")]
        public int WarSupplies { get; set; }
        [DisplayName("Succes Runs")]
        public int SuccesRuns { get; set; }
        [DisplayName("Fail Runs")]
        public int FailRuns { get; set; }
        public string Running { get; set; } = "No";
    }
}
