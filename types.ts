export interface SoftwareToInstall {
  reportDisplayName: string;
  version: number | null;
  brewName: string;
  preInstallCommands?: string[];
  installCommands: string[];
  postInstallCommands?: string[];
}

export interface SoftwareReportItem {
  _name: string;
  arch_kind: string;
  lastModified: Date;
  obtained_from: string;
  path: string;
  signed_by: string[];
  version: string;
}

export interface SoftwareReportList {
  SPApplicationsDataType: SoftwareReportItem[];
}
